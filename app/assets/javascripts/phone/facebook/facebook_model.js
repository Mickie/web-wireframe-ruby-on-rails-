var FacebookModel = function()
{
  this.id = null;
  this.token = null;
  this.name = null;
  this.first_name = null;
  this.last_name = null;
  this.facebook_user_data = null;
  
  this.getProfilePicUrl = function()
  {
    return "https://graph.facebook.com/" + this.id + "/picture?type=square";
  }
}
