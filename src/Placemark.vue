<template>
  <g v-if="target !== undefined && target.position !== undefined" class="placemark" :transform="get_translate()">
    <g :transform="get_scale()">
      <g transform="scale(10) translate(-10, -34)">
        <path class="marker" d="m 9.8764574,31.79142 c -0.338425,-0.310215 -3.09702,-5.15494 -4.9481,-8.689995 C 1.6820824,16.901925 -0.00231761,12.48891 2.3933246e-6,10.189485 0.00400239,6.4328055 2.1654374,2.8789055 5.4922974,1.1597255 7.0703674,0.34424546 8.4572874,0.00391046 10.218242,3.5456334e-5 12.022222,-0.00396454 13.401907,0.33017046 15.006572,1.1595805 c 3.32727,1.719785 5.48861,5.27318 5.492405,9.0299045 0.002,2.29401 -1.69247,6.737965 -4.920215,12.901435 -1.85322,3.53877 -4.61567,8.388045 -4.956345,8.7005 -0.11646,0.106815 -0.25763,0.171875 -0.372925,0.171875 -0.11527,0 -0.2565346,-0.06509 -0.3730346,-0.171875 z"></path>
        <path class="circle" d="m -7.2699413,6.9825382 a 7.943903,7.943903 0 1 1 -15.8878057,0 7.943903,7.943903 0 1 1 15.8878057,0 z" transform="matrix(1.0113978,0,0,1.0113978,25.605491,3.1820663)"></path>
        <foreignObject width="20" height="20" transform="translate(5.2,1.5)">
          <!--<i class="icon-"></i>-->
        </foreignObject>
      </g>
    </g>
  </g>
</template>

<script lang="coffee">
export default {
  
  computed:
    target: () -> @$store.state.selection.target
    transform: () -> @$store.state.additional.transform

  methods:
    get_translate: () -> "translate(#{@target.position[0]}, #{@target.position[1]})"

    get_scale: () -> "scale(#{if @transform? then 1/@transform.k else 1})"

}
</script>

<style scoped>
.placemark {
  pointer-events: none;
}

.placemark .marker {
  fill: #b44646;
}

.placemark path {
  stroke: #742d2d;
  stroke-width: 1px;
}

.placemark .circle {
  fill: #fff;
}

.placemark i {
  color: black;
  font-size: 10px;
}
</style>
