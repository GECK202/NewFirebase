//
//  ChatViewController.swift
//  FB
//
//  Created by Valeria Karon on 7/28/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    
    public var Contragent: String?
    
    private var messages = [Message]()
    
    private let selfSender = Sender(senderId: "1",
                                    displayName: "Joe Smith")
    
    private let selfSender2 = Sender(senderId: "2", displayName: "Bond")
    
    private let selfSender3 = Sender(senderId: "3", displayName: "New")
    
    private var senderNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
          layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
          layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
        view.backgroundColor = .green
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem()
        }
    }
    */
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
      avatarView.isHidden = true
    }
    
    /*
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = "Ivan"
        return NSAttributedString(
            string: name//,
            //attributes: [
            //    .font: UIFont.preferredFont(forTextStyle: .caption1),
            //    .foregroundColor: UIColor(white: 0.3, alpha: 1)
            //]
        )
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 35
    }
     */
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        var curSender: Sender
        var mid: String
        
        switch (senderNumber) {
        case 0:
            curSender = selfSender
            mid = "1"
        case 1:
            curSender = selfSender2
            mid = "2"
        default:
            curSender = selfSender3
            mid = "3"
        }
        senderNumber += 1
        if senderNumber == 3 {
            senderNumber = 0
        }
        
        print("Sending: \(text) \(senderNumber) \(mid)")
        
        messages.append(Message(sender: curSender,
                                messageId: "",
                                sentDate: Date(),
                                kind: .text(text)))
        messagesCollectionView.reloadData()
        messageInputBar.inputTextView.text = ""
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem()
        }
    }
}
