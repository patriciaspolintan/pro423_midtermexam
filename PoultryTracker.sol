// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PoultryTracker {
    
    enum Status { Created, InTransit, Delivered }

    struct Product {
        uint256 id;
        string name; 
        uint256 quantity;
        string origin;
        uint256 timestamp;
        address currentOwner;
        Status status;
        uint256 salePrice; // New: Price in Wei or smallest unit
    }

    address public farmer;
    address public distributor;
    uint256 public productCount;
    
    mapping(uint256 => Product) public products;
    mapping(uint256 => address[]) public ownershipHistory;

    event ProductRegistered(uint256 id, string name, address owner);
    event TransferInitiated(uint256 id, address to, uint256 price);
    event ProductDelivered(uint256 id, address finalOwner);

    modifier onlyFarmer() {
        require(msg.sender == farmer, "Only the farmer can perform this action");
        _;
    }

    constructor(address _distributor) {
        farmer = msg.sender;
        distributor = _distributor;
    }

    // 1. Product Registration (Initial state)
    function registerProduct(string memory _name, uint256 _quantity, string memory _origin) public onlyFarmer {
        productCount++;
        products[productCount] = Product(
            productCount,
            _name,
            _quantity,
            _origin,
            block.timestamp,
            farmer,
            Status.Created,
            0 // Price starts at 0 until transfer
        );
        
        ownershipHistory[productCount].push(farmer);
        emit ProductRegistered(productCount, _name, farmer);
    }

    // 2. Updated Transfer Function with Price Tracking
    function transferToDistributor(uint256 _id, uint256 _price) public onlyFarmer {
        require(products[_id].status == Status.Created, "Product already moved");
        require(_price > 0, "Price must be greater than zero");
        
        products[_id].status = Status.InTransit;
        products[_id].currentOwner = distributor;
        products[_id].salePrice = _price; // Recording the sale value
        
        ownershipHistory[_id].push(distributor);
        
        emit TransferInitiated(_id, distributor, _price);
    }

    function markAsDelivered(uint256 _id) public {
        require(msg.sender == distributor, "Only distributor can confirm");
        require(products[_id].status == Status.InTransit, "Not in transit");

        products[_id].status = Status.Delivered;
        emit ProductDelivered(_id, distributor);
    }

    // Data Retrieval
    function getProductDetails(uint256 _id) public view returns (Product memory) {
        return products[_id];
    }
}