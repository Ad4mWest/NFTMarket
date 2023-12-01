# NFT mobile app

# Links
[Video Design](https://drive.google.com/drive/folders/1sk6FlYoE9pWz9egCnu7uinMKR7IG060N?usp=sharing)

[Figma Design](https://www.figma.com/file/k1LcgXHGTHIeiCv4XuPbND/FakeNFT-(YP)?node-id=96-5542&t=YdNbOI8EcqdYmDeg-0)

# Purpose and goals of the application

The application helps users to view and purchase NFT (NonFungible Token). The purchase functionality is simulated using a side server.

Application Goals:

- viewing NFT collections;
- - viewing and buying NFT (simulated);
- View user ratings.

# Brief description of the application

- The application demonstrates the NFT catalog, structured in the form of collections
- The user can view information about the collection catalog, the selected collection and the selected NFT.
- The user can add favorite NFTs to favorites.
- - The user can delete and add items to the cart, as well as pay for the order (the purchase is simulated).
- The user can view user ratings and user information.
- The user can view information about his profile, including information about favorites and NFTs belonging to him.

Additional (optional) functionality are:
- localization
- dark theme
- statistics based on Yandex.Metrica
- authorization screen
- onboarding screen
- alert with an offer to rate the application
- network error message
- custom launch screen
- Search by table/collection in your epic

# Functional requirements

## Catalog

**Catalog screen**

The catalog screen displays a table (UITableView) showing the available NFT collections. For each collection, the NFT is displayed:
- the cover of the collection;
- name of the collection;
- the number of NFTs in the collection.

There is also a sort button on the screen, when clicked, the user is prompted to select one of the available sorting methods. The contents of the table are ordered according to the selected method.

While the display data is not loaded, the loading indicator should be displayed.

Clicking on one of the table cells takes the user to the screen of the selected NFT collection.

**NFT Collection screen**

The screen displays information about the selected NFT collection, and contains:

- the cover of the NFT collection;
- the name of the NFT collection;
- text description of the NFT collection;
- the name of the author of the collection (link to his website);
- a collection (UICollectionView) with information about the NFT included in the collection.

Clicking on the name of the author of the collection opens his website in a webview.

Each cell in the collection contains:
- NFT image;
- the name of the NFT;
- NFT rating;
- the cost of NFT (in ETH);
- a button for adding to favorites / removing from favorites (heart);
- the button for adding NFT to the cart / removing NFT from the cart.

Clicking on the heart adds NFT to favorites / removes NFT from favorites.

When you click on the add NFT to cart / remove NFT from cart button, the NFT is added or removed from the order (cart). The button image changes at the same time, if the NFT is added to the order, a button with a cross is displayed, if not, a button without a cross.

Clicking on a cell opens the NFT screen.

****NFT Screen**

The screen is partially implemented by the mentor during the lifecycle. The implementation of the screen by students is not required.

## Shopping Cart

**Order screen**

The table screen displays a table (UITableView) with a list of NFTs added to the order.
For each NFT, the following are specified:
- image;
- name;
- rating;
- price;
- the delete button from the trash.

When you click the delete button from the trash, the delete confirmation screen is displayed, which contains:
- NFT image;
- the text about the deletion;
- the delete confirmation button;
- the opt-out button.

There is a sort button at the top of the screen, when clicked, the user is prompted to select one of the available sorting methods. The contents of the table are ordered according to the selected method.    

At the bottom of the screen there is a panel with the number of NFTs in the order, the total price and the payment button.
Clicking on the payment button takes you to the currency selection screen.

While the display data is not loaded or updated, the loading indicator should be displayed.

**Currency selection screen**

The screen allows you to select the currency to pay for the order.

At the top of the screen there is a title and a button to return to the previous screen.
Below it is a collection of UICollectionCell with available payment methods.
For each currency, it is indicated:
- logo;
- full name;
- abbreviated name.

At the bottom there is a text with a link to the user agreement (leads to https://yandex.ru/legal/practicum_termsofuse / , opens in a webview).

There is a payment button under the text, and when it is clicked, a request is sent to the server. If the server responds that the payment was successful, a screen with information about it and a return to cart button is displayed. In case of unsuccessful payment, the corresponding screen is displayed with the buttons to repeat the request and return to the cart.

## Profile

**Profile Screen**

The screen shows information about the user. It contains:
- user's photo;
- user name;
- user description;
- - a table (UITableView) with My NFT cells (leads to the user's NFT screen), NFT Favorites (leads to the screen with NFT favorites), the user's website (opens the user's website in the webview).

There is a profile editing button in the upper right corner of the screen. By clicking on it, the user sees a pop-up screen where they can edit the user's name, description, website and link to the image. You do not need to download the image itself through the application, only the link to the image is updated.

**My NFT Screen**

It is a table (UITableView), each cell of which contains:
- the NFT icon;
- the name of the NFT;
- the author of NFT;
- the price of NFT in ETH.

There is a sort button at the top of the screen, when clicked, the user is prompted to select one of the available sorting methods. The contents of the table are ordered according to the selected method.

If there is no NFT, the corresponding label is displayed.

**NFT Favorites screen**

Contains a collection (UICollectionView) with NFTs added to favorites (liked). Each cell contains information about the NFT:
- icon;
- a heart;
- name;
- rating;
- price in ETH.

Clicking on the heart removes the NFT from favorites, and the contents of the collection are updated.

If there are no selected NFTs, the corresponding label is displayed.

# Sorting the data

There is a sorting setting on the "Catalog", "Trash", "My NFTS", and "Statistics" screens. The sorting order selected by the user must be stored locally on the device. After restarting the application, the previous value is restored.

**Default sorting value:**
- Catalog screen — by the number of NFTs;
- the "Shopping Cart" screen — by name;
- My NFT screen — rated;
- Statistics screen — by rating.
