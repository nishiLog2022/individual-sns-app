//
//  SaveFolderUsecase.swift
//  individual-sns-app
//
import Foundation

class SaveFolderUsecase: SaveFolderUsecaseProtocol {
    private let mstSaveFolderRepository: MstSaveFolderRepositoryProtocol
    private let trnPostRepository: TrnPostRepositoryProtocol

    init(
        mstSaveFolderRepository: MstSaveFolderRepositoryProtocol,
        trnPostRepository: TrnPostRepositoryProtocol
    ) {
        self.mstSaveFolderRepository = mstSaveFolderRepository
        self.trnPostRepository = trnPostRepository
    }

    func getFolders() -> [SaveFolderDto] {
        mstSaveFolderRepository.getFolders().map { $0.createDto() }
    }

    func createFolder(name: String) -> SaveFolderDto {
        let folder = MstSaveFolder(name: name)
        mstSaveFolderRepository.addFolder(folder)
        return folder.createDto()
    }

    func deleteFolder(_ folder: SaveFolderDto) {
        let all = mstSaveFolderRepository.getFolders()
        if let target = all.first(where: { $0.mstSaveFolderId == folder.mstSaveFolderId }) {
            mstSaveFolderRepository.deleteFolder(target)
        }
    }

    func savePost(_ post: PostDto, to folder: SaveFolderDto) -> PostDto {
        var updated = post
        if !updated.savedFolderIds.contains(folder.mstSaveFolderId) {
            updated.savedFolderIds.append(folder.mstSaveFolderId)
        }
        trnPostRepository.update(updated)
        return updated
    }

    func unsavePost(_ post: PostDto, from folder: SaveFolderDto) -> PostDto {
        var updated = post
        updated.savedFolderIds.removeAll { $0 == folder.mstSaveFolderId }
        trnPostRepository.update(updated)
        return updated
    }

    func getPostsInFolder(_ folder: SaveFolderDto, allPosts: [PostDto]) -> [PostDto] {
        allPosts.filter { $0.savedFolderIds.contains(folder.mstSaveFolderId) }
    }

    func ensureDefaultFolder() -> SaveFolderDto {
        mstSaveFolderRepository.ensureDefaultFolderExists().createDto()
    }
}
