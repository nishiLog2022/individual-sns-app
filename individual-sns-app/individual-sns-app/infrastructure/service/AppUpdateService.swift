//
//  AppUpdateService.swift
//  individual-sns-app
//
import Foundation

struct AppUpdateService {

    /// App Storeの最新バージョン情報を取得し、アップデート種別とApp Store URLを返す。
    /// - Returns: アップデートが不要または取得失敗の場合は nil
    func checkForUpdate() async -> (type: AppUpdateType, appStoreURL: URL)? {
#if DEBUG
        // ── 開発時の動作確認用 ──────────────────────────────────────
        // .optional または .forced に変更してシミュレーター/実機で確認できる。
        // 確認が終わったらこのブロックをコメントアウトすること。
//         let debugURL = URL(string: "https://apps.apple.com/jp/app/id000000000")!
//         return (.optional, debugURL)
//         return (.forced, debugURL)
        // ────────────────────────────────────────────────────────────
#endif

        guard let info = await fetchAppStoreInfo() else { return nil }
        guard isNewer(info.version, than: currentVersion) else { return nil }

        let url = URL(string: "https://apps.apple.com/jp/app/id\(info.trackId)")!

        // 強制アップデートが必要な場合はここで最小バージョン要件を確認し .forced を返す。
        // 例: if isNewer("2.0.0", than: info.version) { return (.forced, url) }
        return (.optional, url)
    }

    // MARK: - Private

    private struct AppStoreResult: Decodable {
        let version: String
        let trackId: Int
    }

    private struct AppStoreLookupResponse: Decodable {
        let results: [AppStoreResult]
    }

    private func fetchAppStoreInfo() async -> AppStoreResult? {
        guard let bundleId = Bundle.main.bundleIdentifier,
              let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)&country=jp") else {
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(AppStoreLookupResponse.self, from: data)
            return response.results.first
        } catch {
            return nil
        }
    }

    private var currentVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }

    /// semantic version 比較: candidate が base より新しければ true
    private func isNewer(_ candidate: String, than base: String) -> Bool {
        candidate.compare(base, options: .numeric) == .orderedDescending
    }
}
