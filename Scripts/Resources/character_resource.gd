extends Resource
class_name Character_Resource
#-------------------------------------------------------------------------------
enum GENDER{MALE, FEMALE, NONBINARY}
#-------------------------------------------------------------------------------
@export var face: Texture2D
@export var voice: AudioStream
@export var myGENDER: GENDER
#-------------------------------------------------------------------------------
