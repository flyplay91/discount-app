# Paperclip::Attachment.default_options[:validate_media_type] = false

# Paperclip::Attachment.default_options[:path] = "/Users/anton/work_projects/Work/Shopify/volume_discount/public/uploads/:class/:attachment/:id_partition/:style/:filename"
Paperclip::Attachment.default_options[:validate_media_type] = false
Paperclip.options[:content_type_mappings] = {
  docx: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  pptx: 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  xlsx: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
}