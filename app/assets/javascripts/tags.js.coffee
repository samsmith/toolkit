$ ->
  $("div.tag-form").hide()

  $("div.tag-form li.cancel a").live "click", ->
    $("div.tags").show()
    $("div.tag-form").hide()
    false

  $("a[rel='edit-tags']").live "click", ->
    $("div.tags").hide()
    $("div.tag-form").show()
    false

  $("form.edit-tags").live "ajax:success", (e, data, status, xhr) ->
    $("div.tags-panel").replaceWith(data.tagspanel)
    $("div.tags").show()
    $("div.tag-form").hide()
    $("section.library.box").replaceWith(data.librarypanel) if data.librarypanel
