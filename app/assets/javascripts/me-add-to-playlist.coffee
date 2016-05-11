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
        $('#add_to_playlist').show(500)
        $('#playlist_item_start').val(mejs.Utility.secondsToTimeCode(player.getCurrentTime(), true))
        $('#playlist_item_end').val(mejs.Utility.secondsToTimeCode(player.media.duration, true))

      $('.add_playlist_item_submit').click (event) ->
        alert("haha!")

)(mejs.$)
