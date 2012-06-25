module AttributeHelpers
  def accessible_attributes( aClass, anInstance )
    theAttributes = {}
    aClass.accessible_attributes.each do |anAttribute|
      theAttributes[anAttribute] = anInstance["#{anAttribute}"]
    end
    return theAttributes
  end
end