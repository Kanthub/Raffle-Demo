// const { ethers } = require("ethers");
let provider;
let signer;
let raffleContract;

// 替换为你的合约地址和ABI
const RAFFLE_CONTRACT_ADDRESS = "0x52d64aad6ca10b04EacA47EAf5DDc206BBDB0132";
const RAFFLE_ABI = [
  // 添加你的合约ABI
  {
    type: "function",
    name: "enterRaffle",
    inputs: [],
    outputs: [],
    stateMutability: "payable",
  },
];

window.onload = function () {
  const isConnected = localStorage.getItem("isConnected");
  if (isConnected === "true") {
    connectWalletWithoutPopUp();
    document.getElementById("connectButton").innerText = "连接上啦❤️";
  } else {
    document.getElementById("connectButton").innerText = "还没链接钱包！😬";
  }
};

// alert("yes");
//1
// await window.ethereum.request({ method: "eth_requestAccounts" });
//2
// await ethereum.enable();
//3
// const accounts = await ethereum.request({ method: "eth_requestAccounts" });
// const account = accounts[0];
//4
// 连接 MetaMask
async function connectWallet() {
  if (window.ethereum && window.ethereum.isMetaMask) {
    await window.ethereum.request({
      method: "eth_requestAccounts",
      params: [],
    });
    await window.ethereum.request({
      method: "wallet_requestPermissions",
      params: [{ eth_accounts: {} }],
    });
    provider = new ethers.providers.Web3Provider(window.ethereum);
    // await provider.send("eth_requestAccounts", []);
    signer = provider.getSigner();
    raffleContract = new ethers.Contract(
      RAFFLE_CONTRACT_ADDRESS,
      RAFFLE_ABI,
      signer
    );

    console.log("Wallet connected!");
    document.getElementById("connectButton").innerText = "连接上啦❤️";
    localStorage.setItem("isConnected", "true"); // 保存连接状态
  } else {
    alert("MetaMask is not installed!");
  }
}

// Disconnect
function disconnectWallet() {
  provider = null;
  signer = null;
  raffleContract = null;
  localStorage.setItem("isConnected", "false");
  document.getElementById("connectButton").innerText = "还没链接钱包！😬";
  console.log("Wallet disconnected!");
}

// 连接 MetaMask不弹出
async function connectWalletWithoutPopUp() {
  if (window.ethereum && window.ethereum.isMetaMask) {
    await window.ethereum.request({
      method: "eth_requestAccounts",
      params: [],
    });
    provider = new ethers.providers.Web3Provider(window.ethereum);
    // await provider.send("eth_requestAccounts", []);
    signer = provider.getSigner();
    raffleContract = new ethers.Contract(
      RAFFLE_CONTRACT_ADDRESS,
      RAFFLE_ABI,
      signer
    );
  }
}

// 调用合约函数
async function enterRaffle() {
  if (!raffleContract) {
    alert("Connect your wallet first!!!!!");
    return;
  }

  try {
    // 设置交易参数，带上0.045 ether
    const tx = await raffleContract.enterRaffle({
      value: ethers.utils.parseEther("0.045"),
    });

    // 等待交易完成
    await tx.wait();
    alert("钱收到啦😍祝中奖");
  } catch (error) {
    console.error("Error entering raffle:", error);
    alert("Failed to enter the raffle.");
  }
}

// 绑定按钮事件
// document.getElementById("connectButton").onclick = connectWallet;
document
  .getElementById("connectButton")
  .addEventListener("click", async function () {
    if (signer) {
      disconnectWallet();
    } else {
      // await window.ethereum.request({ method: "eth_requestAccounts" });
      connectWallet();
    }
  });
document.getElementById("enterRaffleButton").onclick = enterRaffle;
