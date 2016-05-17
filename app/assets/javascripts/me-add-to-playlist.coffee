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
        p = $('#post_playlist_id').val()
        $.ajax
          url: '/playlists/'+p+'/items'
          type: 'POST'
          data:
            playlist_item:
              master_file_id: avalonPlayer.active_segment
              title: $('#playlist_item_title').val()
              comment: $('#playlist_item_description').val()
              start_time: $('#playlist_item_start').val()
              end_time: $('#playlist_item_end').val()
          complete: (response) ->
            $('#add_to_playlist_success').show(300)
            $('#add_to_playlist').hide(500)

      $('.add_playlist_item_cancel').click (event) ->
        $('#add_to_playlist').hide(500)

)(mejs.$)
