module MechRL
  module State
    class Ingame < Base
      attr_reader :weapon_keys

      def initialize
        super

        add_view View::Map
        add_view View::Sidebar
        add_view View::Debug

        add_repeatable_command Gosu::KbW, Gosu::KbUp do |delta|
          mech.target_velocity += 20*delta
        end

        add_repeatable_command Gosu::KbS, Gosu::KbDown do |delta|
          mech.target_velocity -= 20*delta
        end

        add_repeatable_command Gosu::KbA do |delta|
          mech.rotate :left, delta
        end

        add_repeatable_command Gosu::KbD do |delta|
          mech.rotate :right, delta
        end

        add_repeatable_command Gosu::KbQ do |delta|
          mech.torso.rotate :left, delta
        end

        add_repeatable_command Gosu::KbE do |delta|
          mech.torso.rotate :right, delta
        end

        add_repeatable_command Gosu::KbF do |delta|
          mech.weapons
            .select { |weapon| weapon.is_selected? }
            .each { |weapon| weapon.shoot nil, delta }
        end

        @weapon_keys = [:Z,:X,:C,:V,:B,:N,:M]

        @weapons = {}
        mech.weapons.each_with_index do |w,i|
            key = @weapon_keys[i]
            @weapons[key] = w
        end

        @weapon_keys.each do |c|
          gosu_key = Gosu.const_get "Kb#{c}"
          add_command gosu_key do
            toggle_weapon c
          end
        end

        (0..9).each do |i|
          gosu_key = Gosu.const_get "Kb#{i}"
          add_command gosu_key do
            i = 10 if i == 0
            mech.target_velocity = (i.to_f/10)*mech.max_velocity
          end
        end
        add_command Gosu::KbBackspace do
          mech.target_velocity = 0
        end
      end

      def toggle_weapon key
        weapon = @weapons[key]
        weapon.toggle_selected unless weapon.nil?
      end

      def update delta
        super delta
        mech.location[:x] %= Constants::Window::ScreenWidth
        mech.location[:y] %= Constants::Window::ScreenHeight
      end
    end
  end
end

