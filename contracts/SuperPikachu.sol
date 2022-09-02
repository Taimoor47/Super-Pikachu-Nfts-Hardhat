// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/security/Pausable.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract Pikachu is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable {
    constructor(
        uint256 _totalLimit,
        uint256 _whitelistLimit,
        uint256 _plateformLimit
    ) ERC721('Super Pikachu', 'SPK') {
        baseURI = 'https://gateway.pinata.cloud/ipfs/';
        mintingBool = true;
        if (_whitelistLimit + _plateformLimit > totalLimit) {
            totalLimit = _totalLimit;
            whitelistLimit = _whitelistLimit;
            plateformLimit = _plateformLimit;
            publicLimit = totalLimit - (whitelistLimit + plateformLimit);
        } else {
            revert NotEqualToTotalLimit();
        }
    }

    //Struct

    struct nftinfo {
        string Name;
        string Hash;
    }

    // Variables

    string public baseURI;
    string public publicSales = 'Unactive';
    string public mintingStatus = 'Active';
    uint256 public totalLimit;
    uint256 public whitelistLimit;
    uint256 public plateformLimit;
    uint256 public publicLimit;
    uint256 public userLimit = 5;
    uint256 private totalLimitCount;
    uint256 private whitelistCount;
    uint256 private publicCount;
    uint256 private plateformCount;
    bool private mintingBool;
    bool private publicSaleBool;

    // Mappings

    mapping(uint256 => nftinfo) public NftData;
    mapping(address => bool) public isWhitelistedUser;
    mapping(address => bool) public isWhitelistedAdmin;
    mapping(address => uint256) public userMintedStatus;

    // Events

    event whitlistUserMinited(address caller,address mintedto,uint tokenId,string name);
    event pulblicUserMinited(address caller,address mintedto,uint tokenId,string name);
    event AdminMinited(address caller,address mintedto,uint tokenId,string name);
    event AdminWhitelisted(address owner,address adminwhitelised );
    event UserWhitelistd(address whitlister,address userwhitelised );
    event AdminRemoved(address removedby,address adminremoved);

    // Custom Erros

    error NotEqualToTotalLimit();
    error WhitelistedAdminAllowed();
    error AdminCannotbeUser();
    error MintingPaused();
    error PublicSaleActive();
    error PublicSaleUnactive();
    error NotWhitelistedUser(address _address);
    error NotWhitelistedAdmin(address _address);
    error TotalLimitReached(uint256 limit);
    error MintingLimitReached(uint256 limit);
    error UserLimitReached(address addrs, uint256 limit);
    error PleaseCheckValue(uint256 limit);
    error AlreadyActive(string status);

    // All Miniting Functions

    /**
     * @dev userMinting is used to mint the Nfts for whitelidted users.
     * userMinting will not work if public sales are active.
     * Once user limit reached then user will not allowd to mint
     * Requirement:
     * - This function can only called by whitelidted users.
     * @param to- reciver address
     * @param tokenId- nft Id 
     * @param _name- name 
     * @param _metadataHash - metadatahash
     * Emits a {whitlistUserMinited} event.
    */

    function userMinting(
        address to,
        uint256 tokenId,
        string memory _name,
        string memory _metadataHash
    ) public {
        if (mintingBool == false) 
        revert MintingPaused();
        if (publicSaleBool == true) 
        revert PublicSaleActive();
        if (isWhitelistedUser[msg.sender] == false) 
        revert NotWhitelistedUser(msg.sender);
        if (totalLimitCount >= totalLimit) 
        revert TotalLimitReached(totalLimit);
        if (whitelistCount >= whitelistLimit) 
        revert MintingLimitReached(whitelistLimit);
        if (userMintedStatus[msg.sender] >= userLimit)
        revert UserLimitReached(msg.sender, userLimit);

        _safeMint(to, tokenId);
        NftData[tokenId] = nftinfo(_name, _metadataHash);
        whitelistCount++;
        totalLimitCount++;
        userMintedStatus[msg.sender]++;
        emit whitlistUserMinited(msg.sender,to,tokenId,_name);
    }

    /**
     * @dev publicMinting is used to mint the Nfts for public. 
     * publicMinting only available when public sales are active.
     * Requirement:
     * @param to- reciver address
     * @param tokenId- nft Id 
     * @param _name- name 
     * @param _metadataHash - metadatahash
     * Emits a {pulblicUserMinited} event.
    */

    function publicMinting(
        address to,
        uint256 tokenId,
        string memory _name,
        string memory _metadataHash
    ) public {
        if (mintingBool == false) 
        revert MintingPaused();
        if (publicSaleBool == false)
         revert PublicSaleUnactive();
        if (totalLimitCount >= totalLimit)
         revert TotalLimitReached(totalLimit);
        if (publicCount >= publicLimit)
         revert MintingLimitReached(publicLimit);
        if (userMintedStatus[msg.sender] >= userLimit)
        revert UserLimitReached(msg.sender, userLimit);

        _safeMint(to, tokenId);
        NftData[tokenId] = nftinfo(_name, _metadataHash);
        publicCount++;
        totalLimitCount++;
        userMintedStatus[msg.sender]++;
        emit pulblicUserMinited(msg.sender,to,tokenId,_name);
    }

    /**
     * @dev platformMinting is for admin minting. 
     * admin will allowd to mint assigned limit by contract and no other ristrictions.
     * Requirement:
     * @param to- reciver address
     * @param tokenId- nft Id 
     * @param _name- name 
     * @param _metadataHash - metadatahash
     * Emits a {pulblicUserMinited} event.
    */

    function platformMinting(
        address to,
        uint256 tokenId,
        string memory _name,
        string memory _metadataHash
    ) public {
        if (isWhitelistedAdmin[msg.sender] == false)
         revert NotWhitelistedAdmin(msg.sender);
        if (totalLimitCount >= totalLimit)
         revert TotalLimitReached(totalLimit);
        if (plateformCount >= plateformLimit)
         revert MintingLimitReached(plateformLimit);

        _safeMint(to, tokenId);
        NftData[tokenId] = nftinfo(_name, _metadataHash);
        plateformCount++;
        totalLimitCount++;
        emit AdminMinited(msg.sender,to,tokenId,_name);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return string(abi.encodePacked(baseURI, NftData[tokenId].Hash));
    }

    /**
     * @dev updateBaseurl is used to update Baseurl.
     * Requirement:
     * - This function can only called by whitelisted admin
     * @param _Url - new Baseurl 
    */

     function updateBaseurl(string memory _Url) public {
        if (isWhitelistedAdmin[msg.sender] == false)
        revert NotWhitelistedAdmin(msg.sender);
        baseURI = _Url;
    }

    /**
     * @dev updateMintingLimit is used to update all user limits.
     * Requirement:
     * - This function can only called by whitelisted admin
     * @param limit - new limit
    */

    function updateMintingLimit(uint256 limit) public {
        if (isWhitelistedAdmin[msg.sender] == false) 
        revert NotWhitelistedAdmin(msg.sender);
        if (limit <= 0) revert PleaseCheckValue(limit);
        userLimit = limit;
    }

    /**
     * @dev whitelistUser is used to whitelist the users.
     * Requirement:
     * - This function can only called by whitelisted admin
     * @param _address - user address
    */

    function whitelistUser(address _address) public {
        if (isWhitelistedAdmin[msg.sender] == false)
         revert WhitelistedAdminAllowed();
        isWhitelistedUser[_address] = true;
        emit UserWhitelistd(msg.sender,_address);
    }

    /**
     * @dev whitelistAdmin is used to whitelist the admin.
     * Requirement:
     * - This function can only called by owner of teh contract
     * @param _address - new admint address
    */

    function whitelistAdmin(address _address) public onlyOwner{
        isWhitelistedAdmin[_address] = true;
        emit AdminWhitelisted(msg.sender,_address);
    }

    /**
     * @dev removeWAdmin is used to remove the admin.
     * Requirement:
     * - This function can only called by owner of teh contract
     * @param _address -  admint address
    */

    function removeWAdmin(address _address) public onlyOwner{
        isWhitelistedAdmin[_address] = false;
        emit AdminRemoved(msg.sender,_address);
    }

    /**
     * @dev publicSalesActDis is used to activate and disable the public sales.
     * Requirement:
     * - This function can only called by owner of teh contract
    */

    function publicSalesActDis() public onlyOwner{    
        if(publicSaleBool == false){
        publicSaleBool = true;
        publicSales = 'Active';
        publicLimit = (publicLimit + whitelistLimit);
        whitelistLimit = whitelistLimit * 0 ;
        }else{
        publicSaleBool = false;
        publicSales = 'Disabled';
        }
      
    }

    /**
     * @dev mintingPusAct is used to activate and pause minting.
     * Requirement:
     * - This function can only called by owner of teh contract
    */

    function mintingPusAct() public onlyOwner {
        if(mintingBool == false){
        mintingBool = true;
        mintingStatus = 'Active';
        }else{
        mintingBool = false;
        mintingStatus = 'Paused';
        }
        
    }

    function pauseContract() public onlyOwner {
        _pause();
    }

    function unpauseContract() public onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }
}
