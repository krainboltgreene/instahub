module LicenseHelper
  def licensify(readme)
    case readme
      when /#{apache.join('|')}/mi then { name: 'Apache', link: 'http://www.opensource.org/licenses/Apache-2.0' }
      when /#{agpl.join('|')}/mi then { name: 'AGPL', link: 'http://www.opensource.org/licenses/AGPL-3.0' }
      when /#{gpl.join('|')}/mi then { name: 'GPL', link: 'http://www.opensource.org/licenses/GPL-3.0' }
      when /#{mit.join('|')}/mi then { name: 'MIT', link: 'http://www.opensource.org/licenses/MIT' }
      when /#{bsd.join('|')}/mi then { name: 'BSD', link: 'http://www.opensource.org/licenses/BSD-3-Clause' }
    end
  end

  def agpl
    [
      "GNU Affero General Public License"
    ]
  end

  def gpl
    [
      "GNU General Public License"
    ]
  end

  def apache
    [
      "Apache License"
    ]
  end

  def bsd
    [
      "Redistribution and use in source and binary forms",
      "BSD License"
    ]
  end

  def mit
    [
      "Permission is hereby granted, free of charge",
      "MIT License"
    ]
  end
end
