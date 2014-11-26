module Pod
  class Installer
    private

    def set_target_dependencies
    end

    class Analyzer
      private

      class AnalysisResult
        def specs_by_target=(specs_by_target)
          current_pod = @podfile_state.added.first

          @specs_by_target = {}
          specs_by_target.each do |target, specs|
            @specs_by_target[target] = specs.reject { |spec| spec.name != current_pod }
          end
        end
      end
    end
  end
end
