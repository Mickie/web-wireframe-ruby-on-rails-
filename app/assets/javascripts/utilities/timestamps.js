function updateTimestamps()
{
  $(".timestamp").timeago();
}

$(function()
{
  jQuery.timeago.settings.strings =
  {
    prefixAgo : null,
    prefixFromNow : null,
    suffixAgo : "",
    suffixFromNow : "from now",
    seconds : "%d s",
    minute : "< 1 m",
    minutes : "%d m",
    hour : "~1 h",
    hours : "%d h",
    day : "~1 d",
    days : "%d d",
    month : "~1 mth",
    months : "%d mth",
    year : "1 y",
    years : "%d y",
    wordSeparator : " ",
    numbers : []
  };

  updateTimestamps();
  setInterval(updateTimestamps, 60000);
});
