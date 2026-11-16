extends GridContainer

@onready var name_label = $NameLabel
@onready var amount_label = $AmountLabel
@onready var incoming_label = $IncomingLabel
@onready var usage_label = $UsageLabel
@onready var runout_label = $RunoutLabel

func _ready() -> void:
	self.modulate = Color.WHITE
	self.columns = 5
	
	for child in self.get_children():
		child.add_theme_color_override("font_color", Color.RED)
		child.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		child.custom_minimum_size = Vector2(100, 100)
		
	self.custom_minimum_size = Vector2(get_viewport().get_visible_rect().size)

func update_display(resource_name: String, resource: Dictionary) -> void:
	name_label.text = resource_name

	var amount: float = resource.get("amount", 0)
	var incoming: float = resource.get("incoming_imports", 0)
	var usage: float = resource.get("use_per_hour", 0)
	
	print(amount, incoming, usage)

	amount_label.text = format_number(amount)	
	incoming_label.text = format_number(incoming)
	usage_label.text = format_number(usage)

	if usage > incoming:
		var hours_remaining = amount / (usage - incoming)
		runout_label.text = format_time(hours_remaining)
	else:
		runout_label.text = "Stable"


func format_number(value: float) -> String:
	return "%s" % int(value)


func format_time(hours: float) -> String:

	if hours < 24:
		return "%.1f hours" % hours

	var days = hours / 24.0

	if days < 365:
		return "%.1f days" % days

	return "%.1f years" % (days / 365.0)
