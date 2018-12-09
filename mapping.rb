require 'json'
reqFile = File.read("req.json")
dataHash = JSON.parse(reqFile)
@structure = Array.new


def buildData toField
	object = Hash.new
	object[:to] = toField
	object[:from] = ""
	object[:defaultValue] = "dummy"
	object[:rules] = []
	object[:datatype] = ""
	object[:description] = ""
	@structure.push(object)
end

def buildList toField
	object = Hash.new
	object[:toParentPath] = ""
	object[:to] = toField
	object[:fromParentPath] = ""
	object[:from] = ""
	object[:isList] = true
	object[:listType] = "LIST_TO_LIST"
	object[:defaultValue] = "dummy"
	object[:rules] = []
	object[:datatype] = ""
	object[:description] = ""
	@structure.push(object)
end

def extractData data
	if data.last.size == 0 
		buildData(data.first)
	else
		data.last.each do |d|
			if d.class == Hash
				d.each do |hashData|
					buildList ("#{data.first}.#{hashData.first}")
				end
			else
				buildData ("#{data.first}.#{d.first}")
			end
		end
	end
end

def processData data
	if data.last.class == String
		buildData(data.first) 
	else
		extractData(data)
	end
end


dataHash.each do |data|
	processData(data)
end

mapFile = File.open("Mapping.json","w")
mapFile.write(@structure.to_json)


