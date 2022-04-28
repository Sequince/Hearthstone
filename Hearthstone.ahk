;Jacob Thomas
;Hearthstone script, automated runs and quality of life improvements
;Created April 1st, 2022



;Personal Hearthstone Scripts, scripts only run with Hearthstone program
#IF WinActive("ahk_exe Hearthstone.exe")

;Pause script in Hearthstone
p::
	Pause
return


;Get the current mouse position, block user input
seqGetMousePos()
{
	CoordMode, Mouse, Window
	blockinput, On	
	MouseGetPos, xpos, ypos
	sleep 50
	seqReturn = %xpos%|%ypos%
	sleep 50
	return seqReturn
}
return

;Move mouse back to stored position, restore user input
seqMoveMousePos(seqxy)
{
	CoordMode, Mouse, Window

	sleep 50
	newXY := StrSplit(seqxy, "|")
	xpos := newXY[1]
	ypos := newXY[2]
	sleep 50
	mousemove, xpos, ypos
	sleep 50
	blockinput, Off
}
return


;Launch Hearthstone auto-grind coins script	
Insert::
CoordMode, Mouse, Window

loop 50
{
	seqLoopNum = %a_index%
	SeqGUIMain4("Run: " seqLoopNum "/50", 800, 5, 0x800080)
	
	loop
	{
		;Check for Choose Mission button from bounties screen
		SeqGUIMain3("Looking for Choose Mission button", 1500, 100)
		ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Choose.png
		if ErrorLevel = 0
		{
			seqxy := seqGetMousePos()
			mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
			seqMoveMousePos(seqxy)
			break
		}
		sleep 150
	}
	sleep ValueSent(4000, 250)
	
	loop
	{
		;Check for Choose Party button from party screen
		SeqGUIMain3("Looking for Choose Party button", 1500, 100)
		ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\ChooseParty.png
		if ErrorLevel = 0
		{
			seqxy := seqGetMousePos()
			mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
			seqMoveMousePos(seqxy)
			sleep 150
			break
		}
		sleep 150
	}
	sleep ValueSent(4000, 250)
	
	;Start battle loops
	loop
	{
		;Look for play/visitor/boon/healer button
		seqLookForPlay()
		sleep ValueSent(1000, 250)

		;Click 0 units played button
		seq01Played()
		sleep ValueSent(1000, 250)

		;Use skill 1 on King Krush until finds Continue Screen
		loop
		{
			seqKrushSkill1()
			sleep ValueSent(1000, 250)
			
			seqLoopNum = 
			quit = no
			
			;Loop through all iterations of 'click to continue' images system uses to prevent bots
			loop 15
			{
				SeqGUIMain3("Looking for Click to continue", 1500, 100)
				ImageSearch, foundx,foundy, 650, 850, 1500, 1150, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\ClickToContinue%seqLoopNum%.png
				if ErrorLevel = 0
				{
					SeqGUIMain3("Found Click To Continue", 1500, 100)
					;seqClickToContinue()
					
					seqxy := seqGetMousePos()
					mouseclick, left, ValueSent(950,20), ValueSent(500,10)
					sleep ValueSent(1000, 250)
					mouseclick, left, ValueSent(950,20), ValueSent(500,10)
					seqMoveMousePos(seqxy)
					
					quit = yes
					sleep 150
					break
				}
				seqLoopNum++
				sleep 100
				quit = no
			}
			;If found Click To Continue, break loop
			if (quit == "yes")
			{
				break
			}
		}
		sleep ValueSent(1000, 250)
		
		;Look for collect reward screen
		loop
		{
			seqCheckForlvl100()
		
			;Check if on treasure screen or done run and break loop
			SeqGUIMain3("Looking for Click Treasure", 1500, 100)
			ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\PickTreasure.png
			if ErrorLevel = 0
			{
				sleep ValueSent(1500, 250)
				seqClickTreasure()
				sleep 150
				break
			}
			sleep 250
			
			victory = no
			sleep 50
			ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\VictoryButton.png
			if ErrorLevel = 0
			{
				victory = yes
				break
			}
			sleep 100
			
			if (a_indeex = 100)
			{
				seqError()
			}
		}
		
		if (victory == "yes")
		{
			SeqGUIMain3("Sleeping 10 seconds waiting for boxes to show up", 1500, 100)
			sleep ValueSent(12000, 550)
			;Add loop to click chests:
			SeqGUIMain3("Clicking Boxes", 1500, 100)

			seqxy := seqGetMousePos()
			mouseclick, left, ValueSent(750,25), ValueSent(300,25)
			seqMoveMousePos(seqxy)
			sleep ValueSent(1150, 550)
			
			seqxy := seqGetMousePos()
			mouseclick, left, ValueSent(1330,25), ValueSent(400,25)
			seqMoveMousePos(seqxy)
			sleep ValueSent(1150, 550)
			
			seqxy := seqGetMousePos()
			mouseclick, left, ValueSent(630,25), ValueSent(760,25)
			seqMoveMousePos(seqxy)
			sleep ValueSent(1150, 550)
			
			seqxy := seqGetMousePos()
			mouseclick, left, ValueSent(1200,25), ValueSent(875,25)
			seqMoveMousePos(seqxy)
			sleep ValueSent(4000, 550)
			
			;Done button after clicking:
			seqxy := seqGetMousePos()
			mouseclick, left, ValueSent(960,25), ValueSent(580,15)
			seqMoveMousePos(seqxy)
			SeqGUIMain3("Clicking okay", 1500, 100)
			sleep ValueSent(3000, 550)
			
			;Bounty Complete screen, Click Okay button
			loop
			{
				seqClickCampfire()
			
				ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Ok.png
				if ErrorLevel = 0
				{
					seqxy := seqGetMousePos()
					mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)	
					seqMoveMousePos(seqxy)
					break
				}
				sleep 150
			}
			sleep ValueSent(6000, 550)
			
			seqClickCampfire()
			
			break
		}
	}
}
	SeqGUIMain("Done!")
	sleep 1000
	reload
return

;Pauses script for set amount of minutes for additional in game currency
seqWaitTime()
{
	Random, seqNum, 1, 3
		if (seqNum = 1)
		{
			FormatTime, SeqHour,, h:mm
			SeqGUIMain3("Started break at: " SeqHour, 1500, 100)
		
			;Uncomment desired sleep time between actions - change this to variable at later date
			;Sleep ValueSent(60000,10000)	;1 mins
			;Sleep ValueSent(450000,60000)	;~8 mins
		Sleep ValueSent(720000,60000)	;12 mins
	
			if WinExist("ahk_exe Hearthstone.exe")
			{
				WinActivate
			}
			SeqGUIMain3("Done sleep", 1500, 100)
		}
}
return

;Click Treasure after each fight
seqClickTreasure()
{
	CoordMode, Mouse, Window
	
	loop
	{
		;Click the Pick Treasure, if found click random
		SeqGUIMain3("Looking for Click Treasure", 1500, 100)
		ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\PickTreasure.png
		{
			seqFoundPickTreasure = %ErrorLevel%
			sleep 100
		}
		ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\KeepOrReplaceTreasure.png
		if ((ErrorLevel = 0) or (seqFoundPickTreasure = 0))
		{
			;Set Y location and 3 valid X locations, get random of the 3, click random one
			SeqGUIMain3("Clicking Treasure", 1500, 100)
			xloc1 := ValueSent(850, 50)
			xloc2 := ValueSent(1150, 50)
			xloc3 := ValueSent(1450, 50)
			yloc := ValueSent(500, 50)

			Random, seqLoc, 1, 3
			sleep 100

			;Click treasure
			seqxy := seqGetMousePos()
			mouseclick, left, xloc%seqLoc%, yloc
			seqMoveMousePos(seqxy)
			sleep ValueSent(1750, 250)
			
			;Click Take button
			seqxy := seqGetMousePos()
			mouseclick, left, ValueSent(1120, 50), ValueSent(920, 15)
			seqMoveMousePos(seqxy)
			sleep 150
			break
		}
		sleep 500
		
		;If at the boss already, look for play and break loop
		SeqGUIMain3("Looking for the Play button", 1500, 100)
		ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Play.png
		if ErrorLevel = 0
		{
			break
		}
		sleep 500
	}
}
return 

;Click to Continue Screen
seqClickToContinue()
{
	loop
	{
		;Click the Click to continue screen
		SeqGUIMain3("Looking for - Click to continue", 1500, 100)

		ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\ClickToContinue.png
			seqFoundClickToContinue = %ErrorLevel%
			sleep 150
		ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\ClickToContinue1.png
			seqFoundClickToContinue2 = %ErrorLevel%
			sleep 150
		ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *55 C:\AutoHotKeyScripts\Pictures\Hearthstone\ClickToContinue3.png
			seqFoundClickToContinue3 = %ErrorLevel%
			sleep 150
		ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\ClickToContinue2.png
		if ((ErrorLevel = 0) or (seqFoundClickToContinue = 0) or (seqFoundClickToContinue2 = 0) or (seqFoundClickToContinue3 = 0))
		{
			SeqGUIMain3("Clicking screen", 1500, 100)
			seqxy := seqGetMousePos()
			mouseclick, left, ValueSent(950,20), ValueSent(500,10)
			seqMoveMousePos(seqxy)
			sleep 150
			break
		}
		sleep 150
	}
	sleep ValueSent(1000, 250)
}
return

;Click 0/1 played button
seq01Played()
{
	loop
	{
		;Click 0/1 played button
		SeqGUIMain3("Looking for the no units played button", 1500, 100)
		ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\02Played.png
		if ErrorLevel = 0
		{
			seqxy := seqGetMousePos()
			mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
			seqMoveMousePos(seqxy)
			sleep 150
			break
		}
		sleep 1000
	}
	sleep ValueSent(1000, 250)
}
return

;Click first Skill for Krush and click Fight button
seqKrushSkill1()
{
CoordMode, Mouse, Window

	;loop 20
	loop
	{
		quit = no
		;Click King Krush skill #1
		SeqGUIMain3("Looking for Krush skill #1", 1500, 100)
		ImageSearch, foundx,foundy, 620, 385, 2900, 650, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\KrushSkill1.png
		if ErrorLevel = 0
		{
			SeqGUIMain3("Found Skill #1", 1500, 100)
			sleep 250
			seqxy := seqGetMousePos()
			sleep 200
			mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
			sleep 350
			seqMoveMousePos(seqxy)
			
			;Test this - Call method to use additional hero skills, use same process for 'if not found' - then won't crash when dead hero
			seqCheckHeros(1)			
			seqCheckHeros(2)
			seqWaitTime()

			break
		}
		sleep 250
		
		;May cause problems if leveling a 'fighter' class someday.  This is here if it can't find the image above.
		SeqGUIMain3("Looking for Skills Window", 1500, 100)
		ImageSearch, foundx,foundy, 600, 370, 940, 640, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\SkillsWindowFighter.png
		if ErrorLevel = 0
		{
			SeqGUIMain3("Found Skill window", 1500, 100)
			sleep 150
			seqxy := seqGetMousePos()
			sleep 150
			mouseclick, left, ValueSent((foundx-65),20), ValueSent((foundy-50), 20)
			sleep 100
			seqMoveMousePos(seqxy)

			sleep 150

			seqWaitTime()

			break
		}
		sleep 250
		
		seqLoopNum =
		quit = no
		loop 15
		{
			;loop through iterations looking for 'click to continue'
			SeqGUIMain3("Looking for click to Continue", 1500, 100)
			Sleep 50
			ImageSearch, foundx,foundy, 650, 850, 1500, 1150, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\ClickToContinue%seqLoopNum%.png
			if ErrorLevel = 0
			{
				quit = yes
				sleep 150
				break
			}
			SeqGUIMain3("Loop number: " seqLoopNum, 1500, 150)
			sleep 150
			seqLoopNum++
		}
		;If found Click To Continue, break loop
		if (quit == "yes")
		{
			break
		}
		sleep 150		
		
		
		seqPotatoLoopNum =
		SeqGUIMain3("Looking for potato", 1500, 100)
		loop 5
		{
			Sleep 50
			ImageSearch, foundx,foundy, 650, 400, 1300, 650, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Spud%seqPotatoLoopNum%.png
			if ErrorLevel = 0
			{
				SeqGUIMain3("Found Potato Skill #1", 1500, 100)
				sleep 250
				seqxy := seqGetMousePos()
				sleep 150
				mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
				sleep 100
				seqMoveMousePos(seqxy)
				
				sleep 150
				break
			}

			sleep 150
			seqPotatoLoopNum++
		}
		
		if (a_index = 20)
		{
			seqError()
		}
	}
	sleep ValueSent(1500, 150)
	
	loop
	{
		;If it ended previous loop because found 'click to continue' then return
		if (quit == "yes")
		{
			break
		}
		
		SeqGUIMain3("Looking for Krush skill #1", 1500, 100)
		sleep 100
		;Assume clicked skill, and click fight?
		ImageSearch, foundx,foundy, 620, 385, 2900, 650, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\KrushSkill1.png
		if ErrorLevel = 0
		{
			SeqGUIMain3("Found Skill #1", 1500, 100)
			sleep 250
			seqxy := seqGetMousePos()
			sleep 150
			mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
			sleep 100
			seqMoveMousePos(seqxy)
			
			;Test this - Call method to use additional hero skills, use same process for 'if not found' - then won't crash when dead hero
			seqCheckHeros(1)			
			seqCheckHeros(2)
			
		}
		if ErrorLevel = 1
		{
			seqxy := seqGetMousePos()
			sleep 100
			;Click on Fight Button
			mouseclick, left, ValueSent(1560,25), ValueSent(495,5)
			sleep 100
			seqMoveMousePos(seqxy)
			sleep 150

			;uncomment to move mouse to card popup for faster runs
			;mousemove, ValueSent(400,30), ValueSent(500,30)
			sleep 2500

			break
		}
		sleep ValueSent(1000, 250)
		
	}
	sleep ValueSent(1000, 250)
}
return


;Check for other heroes skills, pass in hero value to check for
seqCheckHeros(heroNum)
{
CoordMode, Mouse, Window

	SeqGUIMain3("Looking for OTHER hero skills " heroNum, 1500, 100)
	sleep 100
	ImageSearch, foundx,foundy, 620, 385, 1250, 650, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Skill%heroNum%.png
	if ErrorLevel = 0
	{
		SeqGUIMain3("Found BONUS Skill", 1500, 100)
		sleep 250
		seqxy := seqGetMousePos()
		sleep 150
		mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
		sleep 100
		seqMoveMousePos(seqxy)
		sleep ValueSent(600, 150)
	}
	sleep 100
}
return

;Check for level 100+ reward screen
seqCheckForlvl100()
{
	CoordMode, Mouse, Window
	ImageSearch, foundx,foundy, 0, 0, 2900, 1500, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\lvl100Reward.png
	if ErrorLevel = 0
	{
		mouseclick, left, ValueSent(foundx,150), ValueSent(foundy,150)
		sleep 3500
	}
}
return

;If an error, make loud noise if I'm away from PC
seqError()
{
	loop 10
	{
		SoundPlay, C:\Users\Seq\Downloads\icq.mp3
		sleep 1500
	}
}
return

;Look for play/visitor/boon/spirit button in Hearthstone
seqLookForPlay()
{
	loop
	{
		Sleep ValueSent(2050,150)
		Sleep ValueSent(1050,150)
		seqClickCampfire()
	
		Sleep ValueSent(500,50)
		;Check for Choose Play button from mission screen
		SeqGUIMain3("Looking for the Play button", 1500, 100)
		ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Play.png
		if ErrorLevel = 0
		{
			seqxy := seqGetMousePos()
			sleep 100
			mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
			sleep 100
			seqMoveMousePos(seqxy)
			sleep 150
			break
		}
		sleep 250
		;Check for No Mission selected picture if can't find Play
		SeqGUIMain3("Looking for the No Mission selected", 1500, 100)
		if ErrorLevel = 1
		{
			;Click the area where the missions are, if finds Play, clicks it and breaks loop
			;If finds Spirit Healer/Boon, clicks and continues loop, eventually will find Play
			loop 4
			{
				if WinExist("ahk_exe Hearthstone.exe")
				{
					WinActivate
				}
			
				seqClickCampfire()
				
				
				;seqxy := seqGetMousePos()
				mousemove, ValueSent(750,20), ValueSent(500,10)
				;seqMoveMousePos(seqxy)
				if SeqClickVPRButton() = true
				break
				Sleep ValueSent(600,150)
				
				;seqxy := seqGetMousePos()
				mousemove, ValueSent(615,20), ValueSent(500,10)
				;seqMoveMousePos(seqxy)
				if SeqClickVPRButton() = true
				break
				Sleep ValueSent(600,150)
				
				;seqxy := seqGetMousePos()
				mousemove, ValueSent(480,20), ValueSent(500,10)
				;seqMoveMousePos(seqxy)
				if SeqClickVPRButton() = true
				break
				Sleep ValueSent(600,150)
				
				;seqxy := seqGetMousePos()
				mousemove, ValueSent(935,20), ValueSent(500,10)
				;seqMoveMousePos(seqxy)
				if SeqClickVPRButton() = true
				break
				Sleep ValueSent(600,150)
				
				;seqxy := seqGetMousePos()
				mousemove, ValueSent(1085,20), ValueSent(500,10)
				;seqMoveMousePos(seqxy)
				if SeqClickVPRButton() = true
				break
				Sleep ValueSent(600,150)
				
				;Might need additional Y locations?
				
				;seqxy := seqGetMousePos()
				mousemove, ValueSent(750,20), ValueSent(650,10)
				;seqMoveMousePos(seqxy)
				if SeqClickVPRButton() = true
				break
				Sleep ValueSent(600,150)
				
				;seqxy := seqGetMousePos()
				mousemove, ValueSent(615,20), ValueSent(650,10)
				;seqMoveMousePos(seqxy)
				if SeqClickVPRButton() = true
				break
				Sleep ValueSent(600,150)
				
				;seqxy := seqGetMousePos()
				mousemove, ValueSent(480,20), ValueSent(650,10)
				;seqMoveMousePos(seqxy)
				if SeqClickVPRButton() = true
				break
				Sleep ValueSent(600,150)
				
				;seqxy := seqGetMousePos()
				mousemove, ValueSent(935,20), ValueSent(650,10)
				;seqMoveMousePos(seqxy)
				if SeqClickVPRButton() = true
				break
				Sleep ValueSent(600,150)
				
				;seqxy := seqGetMousePos()
				mousemove, ValueSent(1085,20), ValueSent(650,10)
				;seqMoveMousePos(seqxy)
				if SeqClickVPRButton() = true
				break
				Sleep ValueSent(600,150)
			}
			
			seqxy := seqGetMousePos()
			mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
			seqMoveMousePos(seqxy)
			sleep 150
			break
		}
		sleep 250
		
	}
	sleep ValueSent(1000, 250)
}
return


;Check for Visit, Play, or Reveal buttons, and click if found
SeqClickVPRButton()
{
	;Click where the mouse has moved to
	SeqClickDown()
	loop 2
	{
		;click play button from main screen if found
		SeqGUIMain3("Looking for Play", 1500, 100)
		ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Play.png
		if ErrorLevel = 0
		{
			SeqGUIMain3("Found Play", 1500, 100)
			seqxy := seqGetMousePos()
			mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
			seqMoveMousePos(seqxy)
			return true
		}
		sleep 100
		
		SeqGUIMain3("Looking for Boon", 1500, 100)
		ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Reveal.png
		if ErrorLevel = 0
		{
			SeqGUIMain3("Found Boon", 1500, 100)
			seqxy := seqGetMousePos()
			mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
			seqMoveMousePos(seqxy)
			Sleep ValueSent(850,150)
			
			;click screen popup
			seqxy := seqGetMousePos()
			mouseclick, left, ValueSent(1000,150), ValueSent(500,150)
			seqMoveMousePos(seqxy)
			Sleep ValueSent(5850,250)
			return false
		}
		sleep 100
		
		SeqGUIMain3("Looking for Spirit Healer", 1500, 100)
		ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Visit.png
		if ErrorLevel = 0
		{
			SeqGUIMain3("Found Healer", 1500, 100)
			seqxy := seqGetMousePos()
			mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
			seqMoveMousePos(seqxy)
			Sleep ValueSent(7850,1000)
			return false
		}
		sleep 100
		
		SeqGUIMain3("Looking for Warp", 1500, 100)
		ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Warp.png
		if ErrorLevel = 0
		{
			SeqGUIMain3("Found Warp", 1500, 100)
			seqxy := seqGetMousePos()
			mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
			seqMoveMousePos(seqxy)
			Sleep ValueSent(7850,1000)
			return false
		}
		sleep 100
		
		SeqGUIMain3("Looking for Potato", 1500, 100)
		ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\PickUpPotato.png
		if ErrorLevel = 0
		{
			SeqGUIMain3("Found Potato", 1500, 100)
			seqxy := seqGetMousePos()
			mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
			seqMoveMousePos(seqxy)
			Sleep ValueSent(850,150)
			
			;click screen popup
			mouseclick, left, ValueSent(1000,150), ValueSent(500,150)
			Sleep ValueSent(5850,250)
			return false
		}
		sleep 100
		
	}
	;return false
}
return

;Click off the campfire screen
seqClickCampfire()
{
	CoordMode, Mouse, Window
	Sleep ValueSent(2050,150)
	SeqGUIMain3("Looking for Campfire", 1500, 100)
	ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Campfire.png
	if ErrorLevel = 0
	{
		mouseclick, left, ValueSent(1800,100), ValueSent(105,100)
	}
	sleep 150
}
return

;Click down, release method
SeqClickDown()
{
	sleep ValueSent(50,10)
	seqxy := seqGetMousePos()
	click, down left
	sleep ValueSent(50,10)
	click, up left
	seqMoveMousePos(seqxy)
}
return


;Quality of life changes, click buttons without using mouse
~Enter::
CoordMode, Mouse, Window

	;click play button from main screen
	ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Play.png
	if ErrorLevel = 0
	{
		MouseGetPos, xpos, ypos
		sleep 50
		mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
		sleep 150
		mousemove, xpos, ypos
	}
	sleep 100
	
	;click Reveal button from main screen
	ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Reveal.png
	if ErrorLevel = 0
	{
		MouseGetPos, xpos, ypos
		sleep 50
		mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
		sleep 150
		mousemove, xpos, ypos
	}
	sleep 100
	
	;click choose button from bounties screen
	ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Choose.png
	if ErrorLevel = 0
	{
		MouseGetPos, xpos, ypos
		sleep 50
		mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
		sleep 150
		mousemove, xpos, ypos
	}
	sleep 100
	
	;click choose button from Choose Party screen
	ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\ChooseParty.png
	if ErrorLevel = 0
	{
		MouseGetPos, xpos, ypos
		sleep 50
		mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
		sleep 150
		mousemove, xpos, ypos
	}
	sleep 100
	
	;click play button from main screen
	ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Visit.png
	if ErrorLevel = 0
	{
		MouseGetPos, xpos, ypos
		sleep 50
		mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
		sleep 150
		mousemove, xpos, ypos
	}
	sleep 100

	;click 0 played button
	ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\0Played.png
	if ErrorLevel = 0
	{
		MouseGetPos, xpos, ypos
		sleep 50
		mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
		sleep 150
		mousemove, xpos, ypos
	}
	sleep 100
	
	;click 0/1 played button
	ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\01Played.png
	if ErrorLevel = 0
	{
		MouseGetPos, xpos, ypos
		sleep 50
		mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
		sleep 150
		mousemove, xpos, ypos
	}
	sleep 100
	
	loop 13
	{
		ImageSearch, foundx,foundy, 0, 0, 3611, 574, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\FightGreen%seqIncreaseFight%.png
		if ErrorLevel = 0
		{
			;MouseGetPos, xpos, ypos
			sleep 50
			mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
			sleep 150
			;mousemove, xpos, ypos
			mousemove, ValueSent(400,30), ValueSent(500,30)
			
			sleep 150
			break
		}
		sleep 100
		seqIncreaseFight++
	}

	loop 1
	{
		ImageSearch, foundx,foundy, 2689, 856, 3065, 1051, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Victory.png
		if ErrorLevel = 0
		{
			MouseGetPos, xpos, ypos
			sleep 50
			mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)
			sleep 150
			mousemove, xpos, ypos
			
			sleep 150
			break
		}
		sleep 100
		seqIncreaseFight++
	}
	
	return

;While in Hearthstone, remaps Escape key to add better quality of life changes
;Click close buttons, or back buttons without moving mouse
escape::
CoordMode, Mouse, Window
ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Ok.png
if ErrorLevel = 0
{
	MouseGetPos, xpos, ypos
	sleep 50
	mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)	
	sleep 150
	mousemove, xpos, ypos
	return
}

ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *75 C:\AutoHotKeyScripts\Pictures\Hearthstone\Back.png
if ErrorLevel = 0
{
	MouseGetPos, xpos, ypos
	sleep 50
	mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)	
	sleep 150
	mousemove, xpos, ypos
	return
}

ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Back2.png
if ErrorLevel = 0
{
	MouseGetPos, xpos, ypos
	sleep 50
	mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)	
	sleep 150
	mousemove, xpos, ypos
	return
}

ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *75 C:\AutoHotKeyScripts\Pictures\Hearthstone\Back3.png
if ErrorLevel = 0
{
	MouseGetPos, xpos, ypos
	sleep 50
	mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)	
	sleep 150
	mousemove, xpos, ypos
	return
}

ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Done.png
if ErrorLevel = 0
{
	MouseGetPos, xpos, ypos
	sleep 50
	mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)	
	sleep 150
	mousemove, xpos, ypos
	return
}

ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Done2.png
if ErrorLevel = 0
{
	MouseGetPos, xpos, ypos
	sleep 50
	mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)	
	sleep 150
	mousemove, xpos, ypos
	return
}
ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Done3.png
if ErrorLevel = 0
{
	MouseGetPos, xpos, ypos
	sleep 50
	mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)	
	sleep 150
	mousemove, xpos, ypos
	return
}
ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Done4.png
if ErrorLevel = 0
{
	MouseGetPos, xpos, ypos
	sleep 50
	mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)	
	sleep 150
	mousemove, xpos, ypos
	return
}
ImageSearch, foundx,foundy, 0, 0, A_Screenwidth, A_Screenheight, *50 C:\AutoHotKeyScripts\Pictures\Hearthstone\Done5.png
if ErrorLevel = 0
{
	MouseGetPos, xpos, ypos
	sleep 50
	mouseclick, left, ValueSent(20+foundx,20), ValueSent(10+foundy,10)	
	sleep 150
	mousemove, xpos, ypos
	return
}

return
#If