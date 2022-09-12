//
//  ChatViewController.swift
//  FB
//
//  Created by Valeria Karon on 7/28/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import JGProgressHUD

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
    var user: ChatAppUser?
}

class ChatViewController: MessagesViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var messages = [Message]()
    
    private var selfSender = Sender(senderId: "1", displayName: "no name")
    
    private var selfRecipient = Sender(senderId: "2", displayName: "no name")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
        //view.backgroundColor = .green
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
      
    private func listenMessages() {
        //var findMessages = [Message]()
        guard (selfRecipient.user != nil) else {
            print("ERROR!!!")
            return
        }
        print("START DOWNLOAD MESSAGES")
        DatabaseManager.shared.loadMessages(recipient: selfRecipient.user!.emailAddress, completion: { result in
            //self.messages.removeAll()
            for mes in result {
                var sender: SenderType
                if mes.sender == self.selfSender.user!.emailAddress{
                    sender = self.selfSender as SenderType
                } else {
                    sender = self.selfRecipient as SenderType
                }
                let newMessage = self.messages.filter {$0.messageId == mes.id}
                print("NEW MESSGAE=|\(newMessage.count)|")
                if newMessage.count == 0 {
                    let newMes = Message(sender: sender, messageId: mes.id, sentDate: getDate(from: mes.time), kind: .text(mes.text))
                    self.messages.append(newMes)
                }
            }
            //let newMessages = filter(findMessages) { }
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem()
            }
        })
    }
    
    public func configure(recipient: ChatAppUser) {
        guard let user = DatabaseManager.shared.getCurrentUser() else {
            return
        }
        selfSender.senderId = user.id
        selfSender.displayName = user.name
        selfSender.user = user
        
        selfRecipient.senderId = recipient.id
        selfRecipient.displayName = recipient.name
        selfRecipient.user = recipient
        listenMessages()
    }
    
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
    
    //*
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(
            string: name//,
            //attributes: [
            //    .font: UIFont.preferredFont(forTextStyle: .caption1),
            //    .foregroundColor: UIColor(white: 0.3, alpha: 1)
            //]
        )
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 25
    }
     //*/
    
    //*
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
     //*/
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 25
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        spinner.show(in: view)

        
        print("Sending: \(text)")
        
        guard let recipient = selfRecipient.user else {
            print("РЕЦИПИЕНТА НЕТ!!!")
            self.spinner.dismiss()
            return
        }
        
        DatabaseManager.shared.saveMessage(message: text, recipient: recipient.emailAddress, completion: { result in
            //self.messageInputBar.inputTextView.text = ""
            if result == true {
                print("СООБЩЕНИЕ НЕ СОХРАНЕНО!!")
            }
        })
        self.spinner.dismiss()
    }
}
