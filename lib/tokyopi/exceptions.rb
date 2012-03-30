module TokyoPI
  class TokyoPIException < ::Exception ; end

  class GraphiteException < TokyoPIException ; end
  class ConfigurationException < TokyoPIException ; end
  class OhSnapException < TokyoPIException ; end
end
