extends Node

func GetDialogueUI() -> DialogueUI:
	return get_tree().get_nodes_in_group("DialogueUI")[0]
