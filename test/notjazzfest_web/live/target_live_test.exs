defmodule NotjazzfestWeb.TargetLiveTest do
  use NotjazzfestWeb.ConnCase

  import Phoenix.LiveViewTest
  import Notjazzfest.TargetsFixtures

  @create_attrs %{name: "some name", lat: 120.5, lng: 120.5}
  @update_attrs %{name: "some updated name", lat: 456.7, lng: 456.7}
  @invalid_attrs %{name: nil, lat: nil, lng: nil}

  defp create_target(_) do
    target = target_fixture()
    %{target: target}
  end

  describe "Index" do
    setup [:create_target]

    test "lists all targets", %{conn: conn, target: target} do
      {:ok, _index_live, html} = live(conn, ~p"/targets")

      assert html =~ "Listing Targets"
      assert html =~ target.name
    end

    test "saves new target", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/targets")

      assert index_live |> element("a", "New Target") |> render_click() =~
               "New Target"

      assert_patch(index_live, ~p"/targets/new")

      assert index_live
             |> form("#target-form", target: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#target-form", target: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/targets")

      html = render(index_live)
      assert html =~ "Target created successfully"
      assert html =~ "some name"
    end

    test "updates target in listing", %{conn: conn, target: target} do
      {:ok, index_live, _html} = live(conn, ~p"/targets")

      assert index_live |> element("#targets-#{target.id} a", "Edit") |> render_click() =~
               "Edit Target"

      assert_patch(index_live, ~p"/targets/#{target}/edit")

      assert index_live
             |> form("#target-form", target: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#target-form", target: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/targets")

      html = render(index_live)
      assert html =~ "Target updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes target in listing", %{conn: conn, target: target} do
      {:ok, index_live, _html} = live(conn, ~p"/targets")

      assert index_live |> element("#targets-#{target.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#targets-#{target.id}")
    end
  end

  describe "Show" do
    setup [:create_target]

    test "displays target", %{conn: conn, target: target} do
      {:ok, _show_live, html} = live(conn, ~p"/targets/#{target}")

      assert html =~ "Show Target"
      assert html =~ target.name
    end

    test "updates target within modal", %{conn: conn, target: target} do
      {:ok, show_live, _html} = live(conn, ~p"/targets/#{target}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Target"

      assert_patch(show_live, ~p"/targets/#{target}/show/edit")

      assert show_live
             |> form("#target-form", target: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#target-form", target: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/targets/#{target}")

      html = render(show_live)
      assert html =~ "Target updated successfully"
      assert html =~ "some updated name"
    end
  end
end
