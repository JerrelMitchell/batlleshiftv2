class SpaceSerializer < ActiveModel::Serializer
  attributes :coordinates, :status

  def coordinates
    object.coordinates
  end

  def status
    object.status
  end
end
