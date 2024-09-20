module Types
  module Goods
   class SoldAsType < Types::BaseEnum 
     # Define the enum values and their descriptions
     value "PREMIUM", "91-94 octane,for higher-performance vehicles OR those with high compression ratios"
     value "MID_GRADE", "89 octane, for vehicles that require a slightly higher octane rating but not premium."
     value "REGULAR_UNLEADED", "Typically 87 octane, suitable for most passenger vehicles."
     value "GAS","For Gas Product"
     value "OTHERS","For other types of fuel/gas"
   end
  end
 end