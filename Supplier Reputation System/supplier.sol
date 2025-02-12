// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplierReputation {
    struct Supplier {
        string name;
        uint reputation;
        uint totalRatings;
        bool exists;
    }

    mapping(address => Supplier) public suppliers;
    mapping(address => mapping(address => bool)) public hasRated; // Tracks if a buyer has rated a supplier

    event SupplierRegistered(address supplier, string name);
    event SupplierRated(address supplier, uint newReputation);

    function registerSupplier(string memory _name) external {
        require(!suppliers[msg.sender].exists, "Supplier already registered");
        suppliers[msg.sender] = Supplier(_name, 0, 0, true);
        emit SupplierRegistered(msg.sender, _name);
    }

    function rateSupplier(address _supplier, uint _rating) external {
        require(suppliers[_supplier].exists, "Supplier not found");
        require(_rating >= 1 && _rating <= 5, "Rating must be between 1 and 5");
        require(!hasRated[msg.sender][_supplier], "You have already rated this supplier");

        Supplier storage supplier = suppliers[_supplier];
        supplier.reputation = (supplier.reputation * supplier.totalRatings + _rating) / (supplier.totalRatings + 1);
        supplier.totalRatings += 1;
        hasRated[msg.sender][_supplier] = true;

        emit SupplierRated(_supplier, supplier.reputation);
    }

    function getSupplierInfo(address _supplier) external view returns (string memory, uint, uint) {
        require(suppliers[_supplier].exists, "Supplier not found");
        Supplier memory supplier = suppliers[_supplier];
        return (supplier.name, supplier.reputation, supplier.totalRatings);
    }
}
