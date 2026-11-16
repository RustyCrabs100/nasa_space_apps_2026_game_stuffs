extends Node

const RADIATION: float = 33.0 # Nanoseiverts (what is this)
const RADIATION_SICKNESS_LIMIT: float = 100
const RADIATION_DEATH_LIMIT: float = 500

const AMOUNT = "amount"
const INCOMING = "incoming_imports"
const USE_PER_HOUR = "use_per_hour"
const EXPECTED_RUN_OUT_TIME = "expected_run_out_time"

@export var crew_count: int = 8
@export var unused_crew_count: int = crew_count
@export var unhoused_crew_count: int = crew_count

@export var energy: Dictionary = {
	"amount": 500_000,
	"incoming_imports": 0,
	"use_per_hour": 0,
	"expected_run_out_time": 0.0,
}

@export var oxygen: Dictionary = {
	"amount": 1_000_000,
	"incoming_imports": 0,
	# https://ntrs.nasa.gov/api/citations/20190027563/downloads/20190027563.pdf
	# 1 is a rounded estimate, 24 is the hours
	"use_per_hour": (1.0/ 24.0) * crew_count,
	"expected_run_out_time": 0.0
}

@export var water: Dictionary = {
	"amount": 100_000,
	"incoming_imports": 0,
	# https://ntrs.nasa.gov/api/citations/20190027563/downloads/20190027563.pdf
	# 3 is a rounded estimate, 24 is the hours
	"use_per_hour": (3.0 / 24.0) * crew_count,
	"expected_run_out_time": 0.0
}

@export var wiring: Dictionary = {
	"amount": 1_000,
	"incoming_imports": 0,
	"use_per_hour": 0,
	"expected_run_out_time": 0.0
}

@export var hot_food: Dictionary = {
	"amount": 2_000,
	"incoming_imports": 0,
	# https://ntrs.nasa.gov/api/citations/20190027563/downloads/20190027563.pdf
	# 1 is rounded estimate, 24 is hours
	# 3 is the divder for hot and dry food and 2 is the distribution
	"use_per_hour": (1 / 24) * crew_count / 3 * 2,
	"expected_run_out_time": 0.0
}

@export var dry_food: Dictionary = {
	"amount": 3_500,
	"incoming_imports": 0,
	# https://ntrs.nasa.gov/api/citations/20190027563/downloads/20190027563.pdf
	# see above var
	"use_per_hour": (1 / 24) * crew_count / 3 ,
	"expected_run_out_time": 0.0
}

@export var samples: Dictionary = {
	"amount": 0,
	"incoming_imports": 0,
	"use_per_hour": 0,
	"expected_run_out_time": 0.0
}

@export var funds: Dictionary = {
	"amount": 1_000_000,
	"incoming_imports": 0,
	"use_per_hour": 10,
	"expected_run_out_time": 0.0
}

@export var constructables: Dictionary = {
	"amount": 1_000,
	"incoming_imports": 0,
	"use_per_hour": 0,
	"expected_run_out_time": 0.0
}

@export var shielding: Dictionary = {
	"amount": 2_500,
	"incoming_imports": 0,
	"use_per_hour": 0,
	"expected_run_out_time": 0.0
}

@export var metals: Dictionary = {
	"amount": 1_000,
	"incoming_imports": 0,
	"use_per_hour": 0,
	"expected_run_out_time": 0.0
}
