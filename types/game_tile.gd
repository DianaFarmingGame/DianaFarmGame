class_name GameTile extends Resource


export var name: String


var meta_data: Dictionary


enum MetaTypes {
	SINGLE,
	MULTI,
}
const METAS = [
	{"name": "stratum", "trans": "地层位置", "type": MetaTypes.SINGLE, "options": [
		{"value": "shape", "trans": "形状层"},
		{"value": "material", "trans": "地质层"},
		{"value": "surface", "trans": "地表层"},
	]},
]
