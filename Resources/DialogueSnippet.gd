extends Resource
class_name DialogueSnippet

@export var interlocutor : Character
@export_multiline var text : String
@export_enum("PREFERED","RIGHT","LEFT") var side : String = "PREFERED" :
	get:
		if (side == "PREFERED"):
			return interlocutor.prefered_side
		return side
