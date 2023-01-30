class Cart < ApplicationRecord
	validates_uniqueness_of :token
	belongs_to :shop, optional: true

	has_attached_file :attachment, use_timestamp: false
	validates_attachment :attachment, size: { in: 0..50.megabytes }
  do_not_validate_attachment_file_type :attachment
  # attr_accessor :asset_file_name
  # attr_accessor :asset_file_size

	def self.customer_attrs
		['CustomerInfo_FullName', 'CustomerInfo_Title', 'CustomerInfo_EmailAddress', 'CustomerInfo_PhoneNumber', 'CustomerInfo_HomeOffice', 'CustomerInfo_TeamProgramName', 'CustomerInfo_SIDNumber']
	end

	def self.shipping_attrs
		['Shipping_ShipType', 'Single_ShipType', 'CustomerInfo_CostCenter', 'Shipping_Name', 'SingleAddress_Address_Line_1', 'SingleAddress_Address_Line_2', 'SingleAddress_City', 'SingleAddress_StateProvince', 'SingleAddress_PostalCode', 'SingleAddress_CountryRegion', 'SingleAddress_CountryCode', 'DropShip_Address_Type', 'Address_Attachment_Type', 'DeliveryNeededBy_Date', 'DropShip_Addresses', 'Disclaimers', 'DropShipAddress_Attachment_File']
	end
end
