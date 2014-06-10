'use strict'

define (require) ->
  Tool = require 'visualizer/tool'
  Road = require 'model/road'

  class ToolRoadBuilder extends Tool
    constructor: (args...) ->
      super args...
      @sourceIntersection = null
      @road = null
      @dualRoad = null

    mousedown: (e) ->
      cell = @getCell e
      hoveredIntersection = @getHoveredIntersection cell
      if e.shiftKey and hoveredIntersection?
        @sourceIntersection = hoveredIntersection
        e.stopImmediatePropagation()

    mouseup: (e) ->
      @visualizer.world.addRoad @road if @road?
      @visualizer.world.addRoad @dualRoad if @dualRoad?
      @road = @dualRoad = @sourceIntersection = null

    mousemove: (e) ->
      cell = @getCell e
      hoveredIntersection = @getHoveredIntersection cell
      if (@sourceIntersection and hoveredIntersection and
      @sourceIntersection.id isnt hoveredIntersection.id)
        if @road?
          @road.target = hoveredIntersection
          @dualRoad.source = hoveredIntersection
        else
          @road = new Road @sourceIntersection, hoveredIntersection
          @dualRoad = new Road hoveredIntersection, @sourceIntersection
      else
        @road = @dualRoad = null

    mouseout: (e) ->
      @road = @dualRoad = @sourceIntersection = null

    draw: ->
      @visualizer.drawRoad @road, 0.4 if @road?
      @visualizer.drawRoad @dualRoad, 0.4 if @dualRoad?
