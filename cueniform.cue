package cueniform

#Settings: {
	#Terraform:    _
	#Entities:     _
	configuration: _

	#Renamer: *#Terraform.#Renamer | {#In: string, #Out: string, _}

	_entities: {
		#Terraform.#Entities
		#Entities
	}

	#Configuration: #Terraform.#Configuration & {
		data?: [Type=string]: [Name=string]:     _entities[Type].#DataSource
		resource?: [Type=string]: [Name=string]: _entities[Type].#Resource
	}

	#Configuration: {
		resource?: [Type=string]: [Name=string]: {
			let new_name = {#Renamer & {#In: Name}}.#Out
			#tfid:  new_name
			#tfref: "\(Type).\(#tfid)"
		}
		data?: [Type=string]: [Name=string]: {
			let new_name = {#Renamer & {#In: Name}}.#Out
			#tfid:  new_name
			#tfref: "data.\(Type).\(#tfid)"
		}
	}

	cueniform: {
		for k, v in configuration
		if ( k != "resource" && k != "data" ) {(k): v}

		for entity in [ "resource", "data"]
		if configuration[entity] != _|_
		for entity_type, entities in configuration[entity]
		for entity_name, entity_config in entities
		let new_name = {#Renamer & {#In: entity_name}}.#Out {
			(entity): (entity_type): (new_name): entity_config
		}
	}
}
