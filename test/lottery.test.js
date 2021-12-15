const { expect } = require("chai")
const { BN } = require("@openzeppelin/test-helpers")
const lottery = artifacts.require("Lottery")

contract("lottery", async (accounts) => {
    let lotto
    const [alice, bob, carol] = accounts

    before(async () => {
        lotto = await lottery.new(new BN(2), 10)
    })

    describe("Ownable", async () => {
        it("should transfer ownership", async () => {
            expect(await lotto.owner()).to.not.eq(bob)
            await lotto.transferOwnership(bob)
            expect(await lotto.owner()).to.eq(bob)
        })
    })

    describe("Play", async () => {
        it("should increase balance", async () => {
            let balance = await lotto.getBalance()
            expect(String(balance)).to.equal("0");

            await lotto.buy({ value: new BN(2), from: alice })
            balance = await lotto.getBalance()
            expect(String(balance)).to.equal("2");

            await lotto.buy({ value: new BN(2), from: carol })
            balance = await lotto.getBalance()
            expect(String(balance)).to.equal("4");
        })
    })
})
