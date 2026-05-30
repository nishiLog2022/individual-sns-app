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
        // フォルダを参照している投稿からIDを削除
        let postsInFolder = trnPostRepository.getAllPosts()
            .filter { $0.savedFolderIds.contains(folder.mstSaveFolderId) }
        for post in postsInFolder {
            var dto = post.createDto()
            dto.savedFolderIds.removeAll { $0 == folder.mstSaveFolderId }
            trnPostRepository.update(dto)
        }
        // フォルダを削除
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
        // 非デフォルトフォルダへの保存時はデフォルトフォルダにも自動追加
        if !folder.isDefault {
            let allFolders = mstSaveFolderRepository.getFolders()
            if let defaultFolder = allFolders.first(where: { $0.isDefault }),
               !updated.savedFolderIds.contains(defaultFolder.mstSaveFolderId) {
                updated.savedFolderIds.append(defaultFolder.mstSaveFolderId)
            }
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

    func unsaveFromAllFolders(_ post: PostDto) -> PostDto {
        var updated = post
        updated.savedFolderIds.removeAll()
        trnPostRepository.update(updated)
        return updated
    }

    func ensureDefaultFolder() -> SaveFolderDto {
        mstSaveFolderRepository.ensureDefaultFolderExists().createDto()
    }
}
