defmodule LadderTest do
  use ExUnit.Case
  doctest Ladder

  describe "Ladder runner" do
    test "almost all cases test" do
      task_list = %{
        task1: {Ladder.TestHelper, :task_exec, [1]},
        task2: {Ladder.TestHelper, :task_exec, [2], [4, 6, 8]},
        task3: {Ladder.TestHelper, :task_exec, [:ladder_resp]},
        task4: {Ladder.TestHelper, :task_exec, [4]},
        task5: {Ladder.TestHelper, :task_exec, [5]},
        task6: {Ladder.TestHelper, :task_exec, [6]},
        task7: {Ladder.TestHelper, :task_exec, [7]},
        task8: {Ladder.TestHelper, :task_exec, [8]}
      }

      rule = %{
        task1: %{
          task6: :task8,
        },
        task4: :task5,
        task2: [:task7, :task3]
      }

      assert Ladder.run(task_list, rule) == [
               {:task1, 1, [{:task6, 36, {:task8, 64, :accepted_no_check}}]},
               {
                 :task2,
                 4,
                 [
                   {:task7, 49, :accepted_no_check},
                   {:task3, 16, :accepted_no_check}
                 ]
               },
               {:task4, 16, {:task5, 25, :accepted_no_check}}
             ]

    end
  end
end
