import { Grid, Box, useTheme } from "@mui/material";
import * as React from "react";

type AuthBoxProps = {
  children: React.ReactNode;
  imageUrl?: string;
  fallbackColor?: string;
};

export default function AuthBox({
  children,
  imageUrl = "/images/s1.jpg",
  fallbackColor = "#111",
}: AuthBoxProps) {
  const theme = useTheme();

  return (
    <Grid
      container
      sx={{
        minHeight: "100vh",
        overflow: "hidden",
      }}
    >
      <Grid
        item
        xs={12}
        md={6}
        sx={{
          backgroundColor: "red",
          height: "100%",
        }}
      >
        <Box
          sx={{
            position: "absolute",
            width: "100%",
          }}
        />
      </Grid>

      <Grid
        item
        xs={12}
        md={6}
        sx={{
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          px: { xs: 2.5, sm: 4, md: 6 },
          py: { xs: 6, md: 0 },
        }}
      >
        <Box sx={{ width: "100%", maxWidth: 440 }}>{children}</Box>
      </Grid>
    </Grid>
  );
}
