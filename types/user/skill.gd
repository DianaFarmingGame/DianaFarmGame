extends Control

class_name SkillTree

var config_path = "res://config/skill.cfg"
var fields: Array = ["proficiency","mp_consume","improve"]

var skill_proficiency = {}
var proficiency_threshold = {}
var skill_consume = {}
var skill_improve = {}

func _init():
	load_config()

func get_consume(skill_name: String):
	var proficiency = skill_proficiency.get(skill_name)
	var threshold = proficiency_threshold.get(skill_name)
	var consume = skill_consume.get(skill_name)
	var level = -1
	for i in threshold:
		if proficiency >= i:
			level += 1
		else :
			break
	print(level)
	print(consume[level])
	return consume[level]

func improve_skill(skill_name: String):
	var improve = skill_improve.get(skill_name)
	skill_proficiency[skill_name] += improve

func load_config():
	var item_data = ConfigLoader.load_config(config_path,fields)
	for item in item_data:
		var skill_name = item
		# 默认所有技能都拥有，初始化熟练度为0
		skill_proficiency[skill_name] = 0;
		proficiency_threshold[skill_name] = item_data[item]["proficiency"]
		skill_consume[skill_name] = item_data[item]["mp_consume"]
		skill_improve[skill_name] = item_data[item]["improve"]
