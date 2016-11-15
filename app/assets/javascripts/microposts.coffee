# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  new PictureCropper()

class PictureCropper
  constructor: ->
    $('#cropbox').Jcrop
      setSelect: [0, 0, 720, 270]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#micropost_crop_x').val(coords.x)
    $('#micropost_crop_y').val(coords.y)
    $('#micropost_crop_w').val(coords.w)
    $('#micropost_crop_h').val(coords.h)