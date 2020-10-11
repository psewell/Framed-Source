tips = {
	"The Bowie Knife can get a kill from the front.",
	"The Dragunov is good for long range engagements.",
	"Use the Flashbang to disorient your targets.",
	"Don't be too suspicious! Your target can damage you.",
	"It's not over when you get your last target! You have to escape as well.",
	"Remember to check your target with the Check Target tool.",
	"If you see someone kill another player and you are told that you have a new hunter, they are your hunter!",
	"Police will hunt you if you kill someone who is not your target. You will also be shamed.",
	"It is very hard to kill police.",
	"Watch out for Undercover Cops.",
	"Police are clearly labeled. Use this to your advantage.",
	"The basic knife can only get a one-hit KO from behind.",
	"If you are a Police, work with other Police.",
	"All classes can buy all the special weapons in the ingame shop!",
	"When you hold a drink, you blend in with the party! Use this to your advantage.",
	"You will earn F$ for winning the game and getting kills!",
	"Earn points by killing your target or your hunter.",
	"Weapons from the ingame points shop are especially powerful.",
	"Buy a Radar in the ingame points shop to instantly find your Target.",
	"Buy Body Armor in the points shop ingame as a Police to become harder to kill.",
	"You can't hurt the Police until the Epilogue."
}

while true do
	script.Parent.Text = tips[math.random(1, #tips)]
	wait(10)
end