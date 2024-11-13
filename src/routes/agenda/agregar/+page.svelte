<script lang="ts">
	type Especialidad = {
		id: number;
		nombre: string;
		doctores: Medico[];
	};
	type Medico = {
		doctor: {
			id: number;
			nombre: string;
			apellido: string;
		};
	};
	type Clinica = {
		id: number;
		nombre: string;
	};

	let { data }: { data: { especialidades: Especialidad[]; clinicas: Clinica[] } } = $props();

	const { especialidades, clinicas } = data;

	// Variables para el formulario
	let fecha = $state('');
	let especialidad_id = $state('');
	let medico_id = $state('');
	let clinica_id = $state('');
	let disponible = $state(1);
	let estado = $state('activo');

	// Variables para las listas

	let medicosDisponibles: Medico[] = $state([]);

	//

	// Función que se ejecuta cuando cambia la especialidad
	function handleEspecialidadChange() {
		// Resetear médico seleccionado
		medico_id = '';

		// Encontrar la especialidad seleccionada
		const especialidadSeleccionada = especialidades.find(
			(esp) => esp.id === parseInt(especialidad_id)
		);

		// Actualizar la lista de médicos disponibles
		if (especialidadSeleccionada) {
			medicosDisponibles = especialidadSeleccionada.doctores;
		} else {
			medicosDisponibles = [];
		}
	}
</script>

<div class="container">

	<h2 class="my-5 text-center text-3xl font-semibold">Crear Nuevo Horario en Agenda</h2>

	<form class="form" action="?/grabar" method="post">
		<div class="form-group">
			<label for="fecha">Fecha:</label>
			<input type="datetime-local" id="fecha" name="fecha" bind:value={fecha} required />
		</div>

		<div class="form-group">
			<label for="especialidad">Especialidad:</label>
			<select
				id="especialidad"
				name="especialidad"
				bind:value={especialidad_id}
				onchange={handleEspecialidadChange}
				required
			>
				<option value="">Seleccione una especialidad</option>
				{#each especialidades as especialidad}
					<option value={especialidad.id}>{especialidad.nombre}</option>
				{/each}
			</select>
		</div>

		<div class="form-group">
			<label for="medico">Médico:</label>
			<select id="medico" bind:value={medico_id} name="medico" required disabled={!especialidad_id}>
				<option value="">Seleccione un médico</option>
				{#each medicosDisponibles as medico}
					<option value={medico.doctor.id}>
						{medico.doctor.nombre}
						{medico.doctor.apellido}
					</option>
				{/each}
			</select>
		</div>

		<div class="form-group">
			<label for="clinica">Clínica:</label>
			<select id="clinica" bind:value={clinica_id} name="clinica" required>
				<option value="">Seleccione una clínica</option>
				{#each clinicas as clinica}
					<option value={clinica.id}>{clinica.nombre}</option>
				{/each}
			</select>
		</div>

		<div class="form-group">
			<label for="disponible">Disponible:</label>
			<input type="checkbox" id="disponible" name="disponible" bind:checked={disponible} />
		</div>

		<div class="form-group">
			<label for="estado">Estado:</label>
			<select id="estado" bind:value={estado} name="activo">
				<option value="activo">Activo</option>
				<option value="inactivo">Inactivo</option>
			</select>
		</div>

		<button type="submit" class="submit-button">Crear Horario</button>
	</form>
</div>

<style>
	.container {
		max-width: 600px;
		margin: 0 auto;
		padding: 20px;
	}

	.form {
		display: flex;
		flex-direction: column;
		gap: 15px;
	}

	.form-group {
		display: flex;
		flex-direction: column;
		gap: 5px;
	}

	label {
		font-weight: bold;
	}

	input,
	select {
		padding: 8px;
		border: 1px solid #ccc;
		border-radius: 4px;
	}

	select:disabled {
		background-color: #f5f5f5;
		cursor: not-allowed;
	}

	.submit-button {
		padding: 10px;
		background-color: #4caf50;
		color: white;
		border: none;
		border-radius: 4px;
		cursor: pointer;
	}

	.submit-button:hover {
		background-color: #45a049;
	}
</style>
