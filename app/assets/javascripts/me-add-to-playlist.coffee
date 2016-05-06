(($)->

  $.extend mejs.MepDefaults,
    addToPlaylistEnabled: false
    
  $.extend MediaElementPlayer::,
    buildaddToPlaylist: (player, controls, layers, media) ->

      return unless player.options.addToPlaylistEnabled
      
      button = $("<div class='mejs-button mejs-add-to-playlist'>
                    <button type='button' aria-controls='mep_0' title='Add to playlist' aria-label='Add to Playlist'/>
                  </div>")
      button.appendTo(controls)

      button.click (event) ->
        $offset = player.getCurrentTime()
        alert $offset
        $('#add_to_playlist').show()

)(mejs.$)
