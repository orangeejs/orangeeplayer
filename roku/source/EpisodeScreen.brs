sub ShowEpisodeScreen(rss_or_csv_url, leftBread, rightBread)
  print "ShowEpisodeScreen"

	screen = CreateObject("roPosterScreen")
	screen.SetMessagePort(CreateObject("roMessagePort"))
  screen.SetListStyle("flat-category")
  screen.SetBreadcrumbText(leftBread, rightBread)
	screen.Show()

  if Right(rss_or_csv_url, 4) = ".csv" or Right(rss_or_csv_url, 4) = ".txt"
    content = ParseCSV(rss_or_csv_url)
  else
	  mrss = NWM_MRSS(rss_or_csv_url)
	  content = mrss.GetEpisodes()
  end if
	selectedEpisode = 0
	screen.SetContentList(content)
  if content <> invalid AND content.Count() > 0
    screen.AddHeader("Referer", content[0].url)
  end if
	screen.Show()

	while true
		msg = wait(0, screen.GetMessagePort())
		
		if msg <> invalid
			if msg.isScreenClosed()
				exit while
			else if msg.isListItemFocused()
				selectedEpisode = msg.GetIndex()
			else if msg.isListItemSelected()
				selectedEpisode = ShowSpringboardScreen(content, selectedEpisode, leftBread, "")
				screen.SetFocusedListItem(selectedEpisode)
				'screen.Show()
			else if msg.isRemoteKeyPressed()
        if msg.GetIndex() = 13
					ShowVideoScreen(content[selectedEpisode])
				end if
			end if
		end if
	end while
end sub
