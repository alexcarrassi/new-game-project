class_name PointsDB extends Resource


@export var pointMappingP1: Dictionary[int, AtlasTexture]
@export var pointMappingP2: Dictionary[int, AtlasTexture]

func getPointRect(player_index: int, points: int) -> AtlasTexture:
	
	match player_index:
		1: 
			return _getPointRect(points, self.pointMappingP1)
		2:
			return _getPointRect(points, self.pointMappingP1)
		_:
			return _getPointRect(points,  self.pointMappingP1)
			
func _getPointRect(points: int, pointMapping: Dictionary[int, AtlasTexture]) -> AtlasTexture:
	if(pointMapping[points]):
		return pointMapping[points]
	
	return null
	
			
		
		
		
		
		
		
	
	
