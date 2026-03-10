import Foundation

final class FavoritesStore: ObservableObject {
  @Published private(set) var favoriteIds: Set<String> = []

  private let key = "motion_library.favorite_ids"
  private let defaults: UserDefaults

  init(defaults: UserDefaults = .standard) {
    self.defaults = defaults
  }

  func load() {
    guard let ids = defaults.array(forKey: key) as? [String] else {
      favoriteIds = []
      return
    }
    favoriteIds = Set(ids)
  }

  func toggle(_ id: String) {
    if favoriteIds.contains(id) {
      favoriteIds.remove(id)
    } else {
      favoriteIds.insert(id)
    }
    persist()
  }

  func isFavorite(_ id: String) -> Bool {
    favoriteIds.contains(id)
  }

  private func persist() {
    defaults.set(Array(favoriteIds), forKey: key)
  }
}
