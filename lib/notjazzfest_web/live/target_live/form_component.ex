defmodule NotjazzfestWeb.TargetLive.FormComponent do
  use NotjazzfestWeb, :live_component

  alias Notjazzfest.Targets

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage target records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="target-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:lat]} type="number" label="Lat" step="any" />
        <.input field={@form[:lng]} type="number" label="Lng" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Target</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{target: target} = assigns, socket) do
    changeset = Targets.change_target(target)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"target" => target_params}, socket) do
    changeset =
      socket.assigns.target
      |> Targets.change_target(target_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"target" => target_params}, socket) do
    save_target(socket, socket.assigns.action, target_params)
  end

  defp save_target(socket, :edit, target_params) do
    case Targets.update_target(socket.assigns.target, target_params) do
      {:ok, target} ->
        notify_parent({:saved, target})

        {:noreply,
         socket
         |> put_flash(:info, "Target updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_target(socket, :new, target_params) do
    case Targets.create_target(target_params) do
      {:ok, target} ->
        notify_parent({:saved, target})

        {:noreply,
         socket
         |> put_flash(:info, "Target created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
