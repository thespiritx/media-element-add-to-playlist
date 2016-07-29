(($)->

  $.extend mejs.MepDefaults,
    addToPlaylistEnabled: false
    addMarkerToPlaylistItemEnabled: false
    playlistItemDefaultTitle: null
    markerDefaultTitle: null

  $.extend MediaElementPlayer::,
    buildaddToPlaylist: (player, controls, layers, media) ->

      return unless player.options.addToPlaylistEnabled

      button = $("<div class='mejs-button mejs-add-to-playlist'>
                    <button type='button' aria-controls='mep_0' title='Add to playlist' aria-label='Add to Playlist'/>
                  </div>")
      button.appendTo(controls)

      button.click (event) ->
        if $('#add_playlist_item_playlists_not_empty')[0].innerHTML == 'false'
          $('#playlist_item_description')[0].value = ''
          $('#playlist_item_title').val(player.options.playlistItemDefaultTitle)
          $('#playlist_item_start').val(mejs.Utility.secondsToTimeCode(player.getCurrentTime(), true))
          if $('a.current-stream').length && typeof($('a.current-stream')[0].dataset.fragmentend) != typeof(undefined)
            end_time = $('a.current-stream')[0].dataset.fragmentend
          else
            end_time = player.media.duration
          $('#playlist_item_end').val(mejs.Utility.secondsToTimeCode(end_time, true))
        $('#add_to_playlist').show(500)
        $('#add_to_playlist_alert').hide(500)

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
          success: (response) ->
            $('#add_to_playlist_alert')[0].className = 'alert alert-success add_to_playlist_alert'
            $('#add_to_playlist_result_message')[0].innerHTML = response.message
            $('#add_to_playlist_alert').show(300)
            $('#add_to_playlist').hide(500)
          error: (response) ->
            $('#add_to_playlist_alert')[0].className = 'alert alert-danger add_to_playlist_alert add_to_playlist_alert_error'
            $('#add_to_playlist_result_message')[0].innerHTML = response.responseJSON.message
            $('#add_to_playlist_alert').show(300)

      $('.add_playlist_item_cancel').click (event) ->
        $('#add_to_playlist').hide(500)
        $('#add_to_playlist_alert').hide(300)

    buildaddMarkerToPlaylistItem: (player, controls, layers, media) ->

      return unless player.options.addMarkerToPlaylistItemEnabled

      button = $("<div class='mejs-button mejs-add-marker-to-playlist-item'>
                    <button type='button' aria-controls='mep_0' title='Add Marker' aria-label='Add Marker to Playlist Item'/>
                  </div>")
      button.appendTo(controls)

      button.click (event) ->
        $('#marker_title').val(player.options.markerDefaultTitle)
        $('#marker_start').val(mejs.Utility.secondsToTimeCode(player.getCurrentTime(), true))
        $('#add_marker_to_playlist_item').show(500)
        $('#add_marker_to_playlist_item_alert').hide(500)

      $('.add_marker_submit').click (event) ->
        $.ajax
          url: '/avalon_marker'
          type: 'POST'
          data:
            marker:
              master_file_id: avalonPlayer.stream_info.id
              playlist_item_id: avalonPlayer.player.domNode.dataset['currentPlaylistItem'] || null
              title: $('#marker_title').val()
              start_time: $('#marker_start').val()
          success: (response) ->
            $('#add_marker_to_playlist_item_alert')[0].className = 'alert alert-success add_marker_to_playlist_item_alert'
            $('#add_marker_to_playlist_item_result_message')[0].innerHTML = response.message
            $('#add_marker_to_playlist_item_alert').show(300)
            $('#add_marker_to_playlist_item').hide(500)
            if $('#markers').length == 0
              new_marker_section = $("<div class='panel-heading' role='tab' id='markers_heading'>
                <h5 class='panel-title '>
                  <a href='#markers_section' class='accordion-toggle collapsed pull-left' data-toggle='collapse'>
                    Markers</a>
                </h5>
              </div>
              <div id='markers_section' class='panel-collapse collapse' role='tabpanel'>
                <div class='panel-body'>
                  <div id='markers' class='container'>
                    <div class='row marker_header'>
                      <div class='col-xs-7 col-md-8'>Name</div>
                      <div class='col-xs-2 col-md-1'>Time</div>
                      <div class='col-xs-3 col-md-3 text-right'>Actions</div>
                    </div>
                  </div>
                </div>
              </div>")
              $('#heading0').after(new_marker_section)
            offset = response.marker.start_time/1000
            offset_str = mejs.Utility.secondsToTimeCode(offset)
            new_marker = $("<div class='row marker' id='marker_row_"+response.id+"' data-offset='"+offset+"' data-marker='"+response.id+"'>
                <form accept-charset='UTF-8' action='/avalon_marker/"+response.id+"' class='edit_avalon_marker' data-remote='true' id='edit_avalon_marker_"+response.id+"' method='post'>
                  <div style='margin:0;padding:0;display:inline'>
                    <input name='utf8' type='hidden' value='&#x2713;' />
                    <input name='_method' type='hidden' value='patch' />
                  </div>
                  <div class='col-xs-7 col-md-8'>
                    <a class='marker_title' data-offset='"+offset+"'>"+response.marker.title+"</a>
                  </div>
                  <div class='col-xs-2 col-md-1'>
                    <span class='marker_start_time'>"+offset_str+"</span>
                  </div>
                  <div class='col-xs-3 col-md-3 text-right'>
                    <button class='btn btn-default btn-xs edit_marker' id='edit_marker_"+response.id+"' name='edit_marker' type='button'>
                      <i class='fa fa-edit' title='Edit'></i> <span class='sm-hidden'>Edit</span>
                    </button>
                    <button class='btn btn-danger btn-xs btn-confirmation' data-placement='top' form='edit_avalon_marker_"+response.id+"' name='delete_marker' type='submit'>
                      <i class='fa fa-times' title='Delete'></i> <span class='sm-hidden'>Delete</span>
                    </button>
                  </div>
                </form>
              </div>");
            later_markers = $('.row.marker[data-offset]').filter(->
              $(this).attr('data-offset') > offset
            )
            if later_markers.length
              later_markers.first().before(new_marker)
            else
              $('#markers').append(new_marker)
            offset_percent = Math.round(if isNaN(parseFloat(offset)) then 0 else (100*offset / currentPlayer.media.duration))
            marker_title = String(response.marker.title).replace(/"/g, '&quot;')+' ['+offset_str+']'
            $('.mejs-time-rail').append('<span class="fa fa-chevron-up scrubber-marker" style="left: '+offset_percent+'%" title="'+marker_title+'" data-marker='+response.id+'></span>')
            new_marker.find('button.edit_marker').click(enableMarkerEditForm);
            new_marker.find('.edit_avalon_marker').on('ajax:success', handle_edit_save).on 'ajax:error', (e, xhr, status, error) ->
              alert 'Request failed.'
              return
            new_marker.find('.marker_title').click ->
              if typeof currentPlayer != typeof undefined
                currentPlayer.setCurrentTime parseFloat(@dataset['offset']) or 0
              return
            new_marker.find('button[name="delete_marker"]').popover(
              trigger: 'manual'
              html: true
              content: ->
                button = undefined
                if typeof $(this).attr('form') == typeof undefined
                  button = '<a href=\'' + $(this).attr('href') + '\' class=\'btn btn-xs btn-danger btn-confirm\' data-method=\'delete\' rel=\'nofollow\'>Yes, Delete</a>'
                else
                  button = '<input class="btn btn-xs btn-danger btn-confirm" form="' + $(this).attr('form') + '" type="submit">'
                  $('#' + $(this).attr('form')).find('[name=\'_method\']').val 'delete'
                '<p>Are you sure?</p> ' + button + ' <a href=\'#\' class=\'btn btn-xs btn-primary\' id=\'special_button_color\'>No, Cancel</a>'
            ).click ->
              t = this
              $('.btn-confirmation').filter(->
                this != t
              ).popover 'hide'
              $(this).popover 'show'
              false
            return           
          error: (response) ->
            $('#add_marker_to_playlist_item_alert')[0].className = 'alert alert-danger add_marker_to_playlist_item_alert add_marker_to_playlist_item_alert_error'
            $('#add_marker_to_playlist_item_result_message')[0].innerHTML = response.responseJSON.message
            $('#add_marker_to_playlist_item_alert').show(300)

      $('.add_marker_cancel').click (event) ->
        $('#add_marker_to_playlist_item').hide(500)
        $('#add_marker_to_playlist_item_alert').hide(300)

)(mejs.$)
