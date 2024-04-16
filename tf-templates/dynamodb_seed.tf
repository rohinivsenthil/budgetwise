resource "aws_dynamodb_table_item" "user_seed" {
  table_name = aws_dynamodb_table.users.name
  depends_on = [aws_dynamodb_table.users]

  hash_key = "user_id"

  item = jsonencode({
    "user_id"  : {"S": "1"},
    "name"     : {"S": "John Doe"},
    "email"    : {"S": "john@example.com"},
    "password" : {"S": "password123"},
    "phone"    : {"N": "1234567890"}
  })
}

locals {
  expense_data = [
    {
      "expense_id": "0c51d874-2e11-4f09-9072-5ff9f76621e1",
      "date": "08/22/2023",
      "name": "Subway",
      "category": "Food",
      "amount": 73.9,
      "timestamp": 1692676800
    },
    {
      "expense_id": "720da571-5d73-487f-a246-aa3721023a7a",
      "date": "08/27/2023",
      "name": "Walmart",
      "category": "Groceries",
      "amount": 18.15,
      "timestamp": 1693108800
    },
    {
      "expense_id": "c8f3af87-02c7-41c3-9761-69cdca28b0bd",
      "date": "08/31/2023",
      "name": "Chipotle",
      "category": "Food",
      "amount": 84.56,
      "timestamp": 1693454400
    },
    {
      "expense_id": "9fd8ac38-375a-43b5-8071-85644912b067",
      "date": "09/05/2023",
      "name": "Cantina",
      "category": "Food",
      "amount": 35.4,
      "timestamp": 1693886400
    },
    {
      "expense_id": "ba61bf25-5816-4acb-a395-adacc7b04972",
      "date": "09/10/2023",
      "name": "Costco",
      "category": "Groceries",
      "amount": 65.66,
      "timestamp": 1694318400
    },
    {
      "expense_id": "23f1bb97-285f-47cc-a140-036ec0fb4f4e",
      "date": "09/16/2023",
      "name": "RGE",
      "category": "Utilities",
      "amount": 5.87,
      "timestamp": 1694836800
    },
    {
      "expense_id": "ce225c69-9513-46b3-aff1-1f2d01bd1184",
      "date": "09/17/2023",
      "name": "Wegmans",
      "category": "Groceries",
      "amount": 86.56,
      "timestamp": 1694923200
    },
    {
      "expense_id": "7fb6ae81-d56b-49a5-a3e2-43ce8e3d3483",
      "date": "09/24/2023",
      "name": "Smashburger",
      "category": "Food",
      "amount": 42.99,
      "timestamp": 1695528000
    },
    {
      "expense_id": "ee37c61a-46b9-4f6b-bd34-9c3cf06e69f8",
      "date": "09/28/2023",
      "name": "Target",
      "category": "Groceries",
      "amount": 75.45,
      "timestamp": 1695873600
    },
    {
      "expense_id": "d2f63365-131f-45f7-8c40-f339c21a16fa",
      "date": "10/02/2023",
      "name": "Starbucks",
      "category": "Food",
      "amount": 18.14,
      "timestamp": 1696219200
    },
    {
      "expense_id": "114e1c3d-94bc-4b1c-b800-4f52a21a2285",
      "date": "10/02/2023",
      "name": "Spectrum",
      "category": "Utilities",
      "amount": 13.07,
      "timestamp": 1696219200
    },
    {
      "expense_id": "270204eb-b204-433d-a7a6-7b15cbf53857",
      "date": "10/07/2023",
      "name": "Starbucks",
      "category": "Food",
      "amount": 23.2,
      "timestamp": 1696651200
    },
    {
      "expense_id": "a9aa9024-6890-4e4e-af7b-e2f5597d25bc",
      "date": "10/12/2023",
      "name": "RGE",
      "category": "Utilities",
      "amount": 15.29,
      "timestamp": 1697083200
    },
    {
      "expense_id": "f52ca996-be77-4f66-a9df-5de4021960ae",
      "date": "10/16/2023",
      "name": "Costco",
      "category": "Groceries",
      "amount": 7.24,
      "timestamp": 1697428800
    },
    {
      "expense_id": "cf57a8e7-d0ff-4d84-8f6a-026f5fa214d7",
      "date": "10/16/2023",
      "name": "Chipotle",
      "category": "Food",
      "amount": 13.17,
      "timestamp": 1697428800
    },
    {
      "expense_id": "acc76674-1562-4314-a677-c69f8dcc6ea3",
      "date": "10/21/2023",
      "name": "RGE",
      "category": "Utilities",
      "amount": 48.88,
      "timestamp": 1697860800
    },
    {
      "expense_id": "bae86ecd-ca35-4e65-8b75-0bb0d3357b7b",
      "date": "10/28/2023",
      "name": "Cantina",
      "category": "Food",
      "amount": 43.95,
      "timestamp": 1698465600
    },
    {
      "expense_id": "d727f279-08fb-4858-8254-723901cc3562",
      "date": "11/02/2023",
      "name": "Microsoft",
      "category": "Other",
      "amount": 7.7,
      "timestamp": 1698897600
    },
    {
      "expense_id": "0fdb2f56-28ec-403a-b7e1-b040c6fafac8",
      "date": "11/04/2023",
      "name": "Movie",
      "category": "Other",
      "amount": 78.44,
      "timestamp": 1699070400
    },
    {
      "expense_id": "b39f5e2c-6c72-49df-8bc9-c29c7d5f9336",
      "date": "11/08/2023",
      "name": "RGE",
      "category": "Utilities",
      "amount": 67.16,
      "timestamp": 1699419600
    },
    {
      "expense_id": "bd81da4c-ca78-4bdd-aeec-69207dc3351f",
      "date": "11/12/2023",
      "name": "Movie",
      "category": "Other",
      "amount": 80.64,
      "timestamp": 1699765200
    },
    {
      "expense_id": "4287780d-2084-463d-b796-201a0915e495",
      "date": "11/17/2023",
      "name": "RGE",
      "category": "Utilities",
      "amount": 25.13,
      "timestamp": 1700197200
    },
    {
      "expense_id": "91fb680d-f673-46ea-a7a1-499de0aca9e4",
      "date": "11/25/2023",
      "name": "Costco",
      "category": "Groceries",
      "amount": 49.42,
      "timestamp": 1700888400
    },
    {
      "expense_id": "92f537ef-f755-41a6-94d8-2256d9566c22",
      "date": "12/03/2023",
      "name": "Starbucks",
      "category": "Food",
      "amount": 82.42,
      "timestamp": 1701579600
    },
    {
      "expense_id": "7016d713-0903-45c3-b1a4-190dc219a954",
      "date": "12/05/2023",
      "name": "RGE",
      "category": "Utilities",
      "amount": 91.72,
      "timestamp": 1701752400
    },
    {
      "expense_id": "73588f34-8008-4ae9-a66a-255d887134a4",
      "date": "12/14/2023",
      "name": "Target",
      "category": "Groceries",
      "amount": 48.25,
      "timestamp": 1702530000
    },
    {
      "expense_id": "dcb2d090-6ac8-4c26-97be-793a1bf7c3fd",
      "date": "12/21/2023",
      "name": "RGE",
      "category": "Utilities",
      "amount": 97.63,
      "timestamp": 1703134800
    },
    {
      "expense_id": "0900d0b6-6a18-495d-a198-140a66b608f9",
      "date": "12/23/2023",
      "name": "Smashburger",
      "category": "Food",
      "amount": 32.99,
      "timestamp": 1703307600
    },
    {
      "expense_id": "60206ec5-14fb-41f4-8f44-70c71669f0ce",
      "date": "12/28/2023",
      "name": "Smashburger",
      "category": "Food",
      "amount": 41.8,
      "timestamp": 1703739600
    },
    {
      "expense_id": "376b3cd0-0943-4508-a532-659661e8133f",
      "date": "01/04/2024",
      "name": "eBay",
      "category": "Other",
      "amount": 20.49,
      "timestamp": 1704344400
    },
    {
      "expense_id": "1930a38e-189a-4614-824e-7f99ea8f54fd",
      "date": "01/04/2024",
      "name": "Wegmans",
      "category": "Groceries",
      "amount": 50.24,
      "timestamp": 1704344400
    },
    {
      "expense_id": "105f8843-5090-4c9b-8c48-eb506d759d4f",
      "date": "01/05/2024",
      "name": "Spectrum",
      "category": "Utilities",
      "amount": 45.58,
      "timestamp": 1704430800
    },
    {
      "expense_id": "d881e441-baf4-4717-b1c9-a8cbe13e275b",
      "date": "01/13/2024",
      "name": "Amazon",
      "category": "Other",
      "amount": 42.65,
      "timestamp": 1705122000
    },
    {
      "expense_id": "8e703444-26c9-44e1-ad66-a9c837ccf381",
      "date": "01/18/2024",
      "name": "Amazon",
      "category": "Other",
      "amount": 24.04,
      "timestamp": 1705554000
    },
    {
      "expense_id": "34488840-f18d-4dd5-9479-97101e54807d",
      "date": "01/19/2024",
      "name": "Target",
      "category": "Groceries",
      "amount": 15.17,
      "timestamp": 1705640400
    },
    {
      "expense_id": "2d5c1c52-1669-459e-ae92-e363cccbae74",
      "date": "01/21/2024",
      "name": "Wendy's",
      "category": "Food",
      "amount": 64.81,
      "timestamp": 1705813200
    },
    {
      "expense_id": "80893efc-75ca-4383-95cf-363cb74ada39",
      "date": "01/24/2024",
      "name": "RGE",
      "category": "Utilities",
      "amount": 15.25,
      "timestamp": 1706072400
    },
    {
      "expense_id": "2350d7f9-0b73-4086-a1f4-bb54e1df32b9",
      "date": "02/01/2024",
      "name": "Subway",
      "category": "Food",
      "amount": 31.4,
      "timestamp": 1706763600
    },
    {
      "expense_id": "6df466c0-a9b2-411b-866d-bf9c8b52e61b",
      "date": "02/11/2024",
      "name": "Wegmans",
      "category": "Groceries",
      "amount": 7.76,
      "timestamp": 1707627600
    },
    {
      "expense_id": "61d6a77e-eafb-4110-9661-9ce06f927a46",
      "date": "02/14/2024",
      "name": "Walmart",
      "category": "Groceries",
      "amount": 58.25,
      "timestamp": 1707886800
    },
    {
      "expense_id": "e3084b07-477b-437e-9242-6863304dadfc",
      "date": "02/16/2024",
      "name": "Spectrum",
      "category": "Utilities",
      "amount": 78.79,
      "timestamp": 1708059600
    },
    {
      "expense_id": "cd6b3678-e1b8-49fa-9c00-46bdb0dfa6f5",
      "date": "02/17/2024",
      "name": "Walmart",
      "category": "Groceries",
      "amount": 59.49,
      "timestamp": 1708146000
    },
    {
      "expense_id": "922210ba-f645-4136-a3fa-21c39d5d7fda",
      "date": "02/23/2024",
      "name": "Spectrum",
      "category": "Utilities",
      "amount": 32.48,
      "timestamp": 1708664400
    },
    {
      "expense_id": "f5cddfc3-fdc2-4be9-ae71-3f88b2201a46",
      "date": "02/24/2024",
      "name": "Wegmans",
      "category": "Groceries",
      "amount": 41.23,
      "timestamp": 1708750800
    },
    {
      "expense_id": "608319e3-63f0-4bfd-ba6b-52f072a6835c",
      "date": "03/05/2024",
      "name": "Starbucks",
      "category": "Food",
      "amount": 76.48,
      "timestamp": 1709614800
    },
    {
      "expense_id": "a4a7f933-89ea-4238-b672-78aac95f6e51",
      "date": "03/11/2024",
      "name": "RGE",
      "category": "Utilities",
      "amount": 44.29,
      "timestamp": 1710129600
    },
    {
      "expense_id": "32a6a8ca-36df-442b-8f56-6aecdafb5300",
      "date": "03/18/2024",
      "name": "Amazon",
      "category": "Other",
      "amount": 98.79,
      "timestamp": 1710734400
    },
    {
      "expense_id": "75b83dd4-b0c8-4081-8697-634b05b59b92",
      "date": "03/25/2024",
      "name": "Subway",
      "category": "Food",
      "amount": 95.21,
      "timestamp": 1711339200
    },
    {
      "expense_id": "34a31ac2-7427-4990-8011-5778374a89a1",
      "date": "03/30/2024",
      "name": "Costco",
      "category": "Groceries",
      "amount": 92.16,
      "timestamp": 1711771200
    },
    {
      "expense_id": "21148f94-c975-4d53-b8b2-ca3789405032",
      "date": "04/08/2024",
      "name": "Cantina",
      "category": "Food",
      "amount": 66.31,
      "timestamp": 1712548800
    }
  ]

  daily_total_data = [
  {
    "date": "08/22/2023",
    "value": 73.9,
    "timestamp": 1692676800,
    "daily_total_id": "d8ce4db2-aeec-4f38-ba15-026553c31cc2"
  },
  {
    "date": "08/27/2023",
    "value": 18.15,
    "timestamp": 1693108800,
    "daily_total_id": "12a32145-c8ab-48b6-8a7d-2055b1f461d6"
  },
  {
    "date": "08/31/2023",
    "value": 84.56,
    "timestamp": 1693454400,
    "daily_total_id": "8b42bb4f-1d1e-4dcf-949b-780c8ad711fa"
  },
  {
    "date": "09/05/2023",
    "value": 35.4,
    "timestamp": 1693886400,
    "daily_total_id": "25feec52-f295-4d31-8842-40308a748d8c"
  },
  {
    "date": "09/10/2023",
    "value": 65.66,
    "timestamp": 1694318400,
    "daily_total_id": "772460c0-b370-4feb-afe0-a131ed1713fd"
  },
  {
    "date": "09/16/2023",
    "value": 5.87,
    "timestamp": 1694836800,
    "daily_total_id": "a54454df-8cba-4279-82f5-edc7bce6b896"
  },
  {
    "date": "09/17/2023",
    "value": 86.56,
    "timestamp": 1694923200,
    "daily_total_id": "9ee02cac-ec9e-4cdf-90d9-ea275f1d2686"
  },
  {
    "date": "09/24/2023",
    "value": 42.99,
    "timestamp": 1695528000,
    "daily_total_id": "6b421f09-1cf5-45d4-a5db-e06f1fc9f64b"
  },
  {
    "date": "09/28/2023",
    "value": 75.45,
    "timestamp": 1695873600,
    "daily_total_id": "f34af6df-7cb1-479e-a165-436d2cbea16e"
  },
  {
    "date": "10/02/2023",
    "value": 31.21,
    "timestamp": 1696219200,
    "daily_total_id": "b3291873-239f-40e7-96d6-57eaf970ec09"
  },
  {
    "date": "10/07/2023",
    "value": 23.2,
    "timestamp": 1696651200,
    "daily_total_id": "aedb6257-9133-4b9f-aea1-0b294e3fa6aa"
  },
  {
    "date": "10/12/2023",
    "value": 15.29,
    "timestamp": 1697083200,
    "daily_total_id": "72b1b791-5e55-401c-a0f1-cdda47e6444c"
  },
  {
    "date": "10/16/2023",
    "value": 20.41,
    "timestamp": 1697428800,
    "daily_total_id": "183a152d-b345-4063-93fd-4e217b082557"
  },
  {
    "date": "10/21/2023",
    "value": 48.88,
    "timestamp": 1697860800,
    "daily_total_id": "3f86d3b8-acc2-417d-a9ae-e5c1b7a6521e"
  },
  {
    "date": "10/28/2023",
    "value": 43.95,
    "timestamp": 1698465600,
    "daily_total_id": "d73bfd9f-4e63-450c-83fc-3be5af48b2b2"
  },
  {
    "date": "11/02/2023",
    "value": 7.7,
    "timestamp": 1698897600,
    "daily_total_id": "4777e066-74d9-4329-b8bf-8ea1dbcb7d91"
  },
  {
    "date": "11/04/2023",
    "value": 78.44,
    "timestamp": 1699070400,
    "daily_total_id": "964c05c4-13d3-48eb-8fc4-83ff1df2af01"
  },
  {
    "date": "11/08/2023",
    "value": 67.16,
    "timestamp": 1699419600,
    "daily_total_id": "79854e9f-8a56-49c7-af8c-f6a037223efb"
  },
  {
    "date": "11/12/2023",
    "value": 80.64,
    "timestamp": 1699765200,
    "daily_total_id": "3762d232-6ed8-46fd-a3bc-aeb6f9615f95"
  },
  {
    "date": "11/17/2023",
    "value": 25.13,
    "timestamp": 1700197200,
    "daily_total_id": "bf5f34cf-1a91-4910-a98a-ff1b1d135d85"
  },
  {
    "date": "11/25/2023",
    "value": 49.42,
    "timestamp": 1700888400,
    "daily_total_id": "afbe40cd-ba7b-409c-ac78-8dbb6e8450a0"
  },
  {
    "date": "12/03/2023",
    "value": 82.42,
    "timestamp": 1701579600,
    "daily_total_id": "be5a7a21-791f-4c82-b318-29cc32ee6bab"
  },
  {
    "date": "12/05/2023",
    "value": 91.72,
    "timestamp": 1701752400,
    "daily_total_id": "fcb5a19c-c669-45c4-9857-f4e357c4433d"
  },
  {
    "date": "12/14/2023",
    "value": 48.25,
    "timestamp": 1702530000,
    "daily_total_id": "0ce0aee7-81f4-40fd-bab0-0e2134679695"
  },
  {
    "date": "12/21/2023",
    "value": 97.63,
    "timestamp": 1703134800,
    "daily_total_id": "19a06632-290b-483b-951d-c2e64945c135"
  },
  {
    "date": "12/23/2023",
    "value": 32.99,
    "timestamp": 1703307600,
    "daily_total_id": "24c2258b-9010-4f69-9308-798bcbc51aef"
  },
  {
    "date": "12/28/2023",
    "value": 41.8,
    "timestamp": 1703739600,
    "daily_total_id": "668895e5-7fe0-45d5-b66d-b07eaa90ced3"
  },
  {
    "date": "01/04/2024",
    "value": 70.73,
    "timestamp": 1704344400,
    "daily_total_id": "f02847bf-d93e-449e-b026-c3b2e8d59ca1"
  },
  {
    "date": "01/05/2024",
    "value": 45.58,
    "timestamp": 1704430800,
    "daily_total_id": "6c44a518-bfa8-4fa1-803f-9d512b8e68e7"
  },
  {
    "date": "01/13/2024",
    "value": 42.65,
    "timestamp": 1705122000,
    "daily_total_id": "a71b983a-11a8-45e0-be0e-e8343026fe7a"
  },
  {
    "date": "01/18/2024",
    "value": 24.04,
    "timestamp": 1705554000,
    "daily_total_id": "f724fa7b-f37c-4c1a-8d23-103ec62af9ec"
  },
  {
    "date": "01/19/2024",
    "value": 15.17,
    "timestamp": 1705640400,
    "daily_total_id": "21315d42-066a-43a2-a22a-a712607ae78a"
  },
  {
    "date": "01/21/2024",
    "value": 64.81,
    "timestamp": 1705813200,
    "daily_total_id": "c109fc8e-3000-4613-a058-8ee55cb609e0"
  },
  {
    "date": "01/24/2024",
    "value": 15.25,
    "timestamp": 1706072400,
    "daily_total_id": "6cbe3588-dc99-45b8-81bf-5fcd84909681"
  },
  {
    "date": "02/01/2024",
    "value": 31.4,
    "timestamp": 1706763600,
    "daily_total_id": "b816e321-bbe5-4a52-90e9-a66504e582fb"
  },
  {
    "date": "02/11/2024",
    "value": 7.76,
    "timestamp": 1707627600,
    "daily_total_id": "87cbc746-adb3-486b-ab9d-6594cbe81875"
  },
  {
    "date": "02/14/2024",
    "value": 58.25,
    "timestamp": 1707886800,
    "daily_total_id": "95a51c70-049c-4e48-977c-883763ee4609"
  },
  {
    "date": "02/16/2024",
    "value": 78.79,
    "timestamp": 1708059600,
    "daily_total_id": "20cb0fb0-a138-465b-97e1-d5b4921542b3"
  },
  {
    "date": "02/17/2024",
    "value": 59.49,
    "timestamp": 1708146000,
    "daily_total_id": "c9eb3fd2-8f9c-4f55-bbf2-a92edb9868e3"
  },
  {
    "date": "02/23/2024",
    "value": 32.48,
    "timestamp": 1708664400,
    "daily_total_id": "cb63a117-7b22-4e61-8d6e-93ca4a69e294"
  },
  {
    "date": "02/24/2024",
    "value": 41.23,
    "timestamp": 1708750800,
    "daily_total_id": "eb2a757a-b13b-4c98-b8fa-cdddbe310c12"
  },
  {
    "date": "03/05/2024",
    "value": 76.48,
    "timestamp": 1709614800,
    "daily_total_id": "ac99ba29-e2e0-44a9-a2a9-692f55b4953b"
  },
  {
    "date": "03/11/2024",
    "value": 44.29,
    "timestamp": 1710129600,
    "daily_total_id": "dc82fcd1-840b-4594-93d9-270aa66b9dbb"
  },
  {
    "date": "03/18/2024",
    "value": 98.79,
    "timestamp": 1710734400,
    "daily_total_id": "3a81e40a-3b52-4af8-944e-7295366871de"
  },
  {
    "date": "03/25/2024",
    "value": 95.21,
    "timestamp": 1711339200,
    "daily_total_id": "79c190e3-1d92-43b5-b0d9-2686d91ec76d"
  },
  {
    "date": "03/30/2024",
    "value": 92.16,
    "timestamp": 1711771200,
    "daily_total_id": "8748709c-24b7-474c-b486-6ff4c47b6150"
  },
  {
    "date": "04/08/2024",
    "value": 66.31,
    "timestamp": 1712548800,
    "daily_total_id": "15d15288-6ddb-4ffd-baac-43fc0423aa30"
  }
]
}

resource "aws_dynamodb_table_item" "expenses_seed" {
  for_each    = { for idx, expense in local.expense_data : idx => expense }
  table_name  = aws_dynamodb_table.expenses.name
  depends_on  = [aws_dynamodb_table.expenses]

  hash_key    = "expense_id"

  item = jsonencode({
    "expense_id" : {"S": tostring(each.value.expense_id)},
    "user_id"  : {"S": "1"},
    "date"       : {"S": each.value.date},
    "name"       : {"S": each.value.name},
    "category"   : {"S": each.value.category},
    "amount"     : {"N": tostring(each.value.amount)}
    "timestamp"     : {"N": tostring(each.value.timestamp)}
  })
}

locals {
  budget_categories = {
    "utilities": 700,
    "groceries": 800,
    "food": 1000,
    "other": 500
  }
}

resource "aws_dynamodb_table_item" "budgets_seed" {
  table_name  = aws_dynamodb_table.budgets.name
  depends_on  = [aws_dynamodb_table.budgets]

  hash_key    = "budget_id"

  item = jsonencode({
    "budget_id"  : {"S": "1"},
    "user_id"    : {"S": "1"},
    "amount"     : {"N": "3000"},
    "categories" : {"S": jsonencode(local.budget_categories)}
  })
}

resource "aws_dynamodb_table_item" "daily_total_seed" {
  for_each    = { for idx, daily_total in local.daily_total_data : idx => daily_total }
  table_name  = aws_dynamodb_table.daily_totals.name
  depends_on  = [aws_dynamodb_table.daily_totals]

  hash_key    = "daily_total_id"

  item = jsonencode({
    "daily_total_id"  : {"S": tostring(each.value.daily_total_id)},
    "user_id"    : {"S": "1"},
    "date"     : {"S": tostring(each.value.date)},
    "value" : {"N": tostring(each.value.value)},
    "timestamp" : {"N": tostring(each.value.timestamp)}
  })
}