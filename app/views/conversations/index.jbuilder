json.converstations @conversations do
  json.id @conversation.id
  json.recipient_id conversation.recipient_id
  json.recipient_firstname conversation.recipient.firstname
  json.recipient_lastname conversation.recipient.lastname
  json.recipient_email conversation.recipient.email
  json.sender_id conversation.sender_id
  json.sender_firstname conversation.sender.firstname
  json.sender_lastname conversation.sender.lastname
  json.sender_email conversation.sender.email
  json.created_at conversation.created_at
  json.updated_at conversation.updated_at
end
