# require 'fcm'

# fcm = FCM.new("AAAARsMXXx8:APA91bH_ylxG083jHnqYQb7HPd-i_9dJbMwn7kRsk9HII7qNy0f7TtbadMxO5I3zEjh7OybGu1KtQanJncyVK1Swlr9IDXXyARucgBk9ay4tvLFYaTY5wgftwYHUUGrQ0UeBVTZaVISERvNxKoTxVqP9OAVAjRzi8g")

# registration_ids= ["f79dxkJyrMA:APA91bEPJCkJ6kP0kkptcPv6Hz3LrKmw5yCyvOIaQi6OuHMbDY5_nkMC-9L7Ww1U1RdbMXPwUdbqQ6LCydHa3lJyGBgcaItvfnq__44qvPaK6AXRIFPpuUkkCOb1KolVa7A1P_XuMgzg",
# "cTyHaieofDE:APA91bGVvPo9F70dmaRY1ImlbDeVMJ92r6tWv7mmx4M123oLxGT9MUTKCdi2ikpODNS6OP8GTxVfikI7CIJtz8qEZCfZds5314ie6A_NEvSeecOfmtO0MM8mVfWOJRUqCQa1-HoigvUh"] # an array of one or more client registration tokens

# regtemp= ["e69YHeeOFWs:APA91bGXOe6VYNIYN-1FVBdXQWcLT_mgEzoToztaNprTfgyL1m1tWUBZsXDEWc8XCoL0ILyhS04VSZKv2q6iFg0FlZyliOda0aYAKl_tICd36OKX6xSwWpDvR978ejLu6IVX2IBQEA27"]

# options = {
#         priority: "high",
#         collapse_key: "updated_score", 
#         notification: {
#             title: "Message Title", 
#             body: "Hi, Worked perfectly",
#             icon: "myicon"}
#         }

# response = fcm.send(regtemp, options)

# print response