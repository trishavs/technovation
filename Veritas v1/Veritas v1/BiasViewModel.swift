import Foundation
import Combine

struct BiasRating: Codable {
    let name: String?
    let bias: String?
    let factual: String?
    let credibility: String?
}

class BiasViewModel: ObservableObject {
    @Published var rating: BiasRating?
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Anthropic API Key
    // Replace with your actual Anthropic API key from https://console.anthropic.com
    private let anthropicAPIKey = "YOUR_ANTHROPIC_API_KEY_HERE"

    func checkBias(for input: String) {
        // 1. SANITIZE: Turn "https://evinfo.net/2026/..." into "evinfo.net"
        var clean = input.lowercased()
            .replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "http://", with: "")
            .replacingOccurrences(of: "www.", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if let firstPart = clean.split(separator: "/").first {
            clean = String(firstPart)
        }

        guard !clean.isEmpty else { return }

        self.isLoading = true
        self.rating = nil
        self.errorMessage = nil

        analyzeWithClaude(domain: clean, originalInput: input)
    }

    // MARK: - Claude Analysis

    private func analyzeWithClaude(domain: String, originalInput: String) {
        guard let url = URL(string: "https://api.anthropic.com/v1/messages") else {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Invalid API URL"
            }
            return
        }

        let prompt = """
        Analyze the news source or website "\(domain)" (full URL: \(originalInput)) for media bias and credibility.

        Use your knowledge of media bias research, fact-checking organizations (like Media Bias/Fact Check, AllSides, Ad Fontes Media), and journalistic standards to evaluate this source.

        Return ONLY a valid JSON object with NO other text, preamble, or markdown. The JSON must have exactly these fields:
        {
          "name": "Full publication name",
          "bias": "One of: Far Left / Left / Center-Left / Center / Center-Right / Right / Far Right / Satire / Conspiracy / Unknown",
          "factual": "One of: Very High / High / Mostly Factual / Mixed / Low / Very Low / Satire / Unknown",
          "credibility": "A 1–2 sentence summary of this source's credibility, ownership, known issues, and reliability. Be specific and factual."
        }

        If you don't recognize the domain or have insufficient information, set bias and factual to "Unknown" and explain in credibility that the source is not well-documented in media bias databases.
        """

        // Build the request body with web_search tool enabled
        let requestBody: [String: Any] = [
            "model": "claude-opus-4-5",
            "max_tokens": 512,
            "tools": [
                [
                    "type": "web_search_20250305",
                    "name": "web_search"
                ]
            ],
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ]
        ]

        guard let bodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Failed to build request"
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(anthropicAPIKey, forHTTPHeaderField: "x-api-key")
        request.addValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.addValue("web-search-2025-03-05", forHTTPHeaderField: "anthropic-beta")
        request.httpBody = bodyData
        request.timeoutInterval = 30

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "No response from server"
                    return
                }

                guard httpResponse.statusCode == 200 else {
                    if httpResponse.statusCode == 401 {
                        self.errorMessage = "Invalid API key — check BiasViewModel.swift"
                    } else {
                        self.errorMessage = "API error \(httpResponse.statusCode)"
                    }
                    return
                }

                guard let data = data else {
                    self.errorMessage = "Empty response"
                    return
                }

                self.parseClaudeResponse(data: data)
            }
        }.resume()
    }

    // MARK: - Parse Claude Response

    private func parseClaudeResponse(data: Data) {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let content = json["content"] as? [[String: Any]] else {
            self.errorMessage = "Could not parse API response"
            return
        }

        // Claude may return multiple content blocks (text + tool_use); find the last text block
        let textBlocks = content.filter { $0["type"] as? String == "text" }
        guard let lastTextBlock = textBlocks.last,
              let rawText = lastTextBlock["text"] as? String else {
            self.errorMessage = "No text in response"
            return
        }

        // Strip any accidental markdown fences
        let cleaned = rawText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Find the JSON object within the text
        guard let jsonStart = cleaned.firstIndex(of: "{"),
              let jsonEnd = cleaned.lastIndex(of: "}") else {
            self.errorMessage = "Source not in database"
            return
        }

        let jsonString = String(cleaned[jsonStart...jsonEnd])
        guard let jsonData = jsonString.data(using: .utf8),
              let decoded = try? JSONDecoder().decode(BiasRating.self, from: jsonData) else {
            self.errorMessage = "Could not decode rating"
            return
        }

        self.rating = decoded
    }
}
