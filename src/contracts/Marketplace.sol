pragma solidity ^0.5.16;


contract Marketplace{
    string public name;
    uint public productCount = 0;
    mapping(uint => Product) public products;

    struct Product{
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }

    event ProductCreated(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    event ProductPurchased(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    constructor() public{
        name = "Marketplace";
    }

    function createProduct(string memory _name, uint _price) public{
       require(bytes(_name).length > 0, "Product name cannot be empty");
       require(_price > 0, "Product price must be greater than 0");

        productCount++;
        products[productCount] = Product(productCount, _name, _price, msg.sender, false);
        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }

    function purchaseProduct(uint _id) public payable{
        //fetching product , fetching the owner , making sure prod is valid , purchaase it and then trigger event
        Product memory _product = products[_id];
        address payable _seller = _product.owner;

        require(_product.id > 0 && _product.id <= productCount, "Product does not exist");
        require(msg.value >= _product.price, "Insufficient funds");
        require(!_product.purchased, "Product is already purchased");
        require(_seller != msg.sender, "You cannot purchase your own product");

        _product.owner = msg.sender;
        _product.purchased = true;
        products[_id] = _product;

        address(_seller).transfer(msg.value);
        emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true);
    }
}